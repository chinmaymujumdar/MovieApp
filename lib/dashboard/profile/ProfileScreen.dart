import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/profile/Tabs.dart';
import 'package:movies_app/login/LoginScreen.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  NetworkCall networkCall=NetworkCall();
  bool isFetching=true;
  var user;

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  void getUserDetail() async{
    dynamic user=await networkCall.getUserDetail();
    setState(() {
      isFetching=false;
      this.user=user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isFetching ? Center(child: CircularProgressIndicator()) :Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async{
                  bool logout=await networkCall.logoutUser();
                  if(logout){
                    SharedPreferences pref=await SharedPreferences.getInstance();
                    pref.remove(kSessionId);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'LOGOUT',
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage('$kAvatarBaseURL${user['avatar']['gravatar']['hash']}'),
                radius: 75.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                user['username'],
                style: TextStyle(
                  fontFamily: 'Roboto-Medium',
                  color: Colors.white,
                  fontSize: 23.0,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: Tabs(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
