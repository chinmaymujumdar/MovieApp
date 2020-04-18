import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/StatefulWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app/Constants.dart';
import 'package:movies_app/dashboard/Dashboard.dart';
import 'package:movies_app/login/LoginScreen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NetworkCall networkCall=NetworkCall();

  @override
  void initState() {
    init(context);
    super.initState();
  }

  void init(BuildContext context) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String sessionId=pref.getString(kSessionId);
    Widget widget;
    print(sessionId);
    if(sessionId==null||sessionId.isEmpty){
      widget=LoginScreen();
    }else{
      widget=Dashboard();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => widget),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image(
              height: 125.0,
              width: 125.0,
              image: AssetImage('images/logo.png')
          ),
        ),
      )
     );
  }
}

