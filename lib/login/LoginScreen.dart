import 'package:flutter/material.dart';
import 'package:movies_app/Utils.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/dashboard/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:movies_app/Constants.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passController=TextEditingController();
  NetworkCall networkCall=NetworkCall();
  bool _isLoginInProcess=false;
  bool _containerType=true;
  String url;
  Timer timer;
  double progressvalue=0.0;

  void _changeLoginProgressStatus(bool status){
    setState(() {
      _isLoginInProcess=status;
    });
  }

  void _saveSessionId(http.Response response) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString(kSessionId, json.decode(response.body)['session_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('images/image.jpg'),fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(220,26,26,26),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto-Bold',
                          fontSize: 35.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Please sign in to continue',
                        style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: emailController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Icon(Icons.email,color: Colors.orange,)
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: passController,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                style: TextStyle(
                                    color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Icon(Icons.security,color: Colors.orange,),
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        url="https://www.themoviedb.org/account/reset-password";
                                        _containerType=false;
                                      });
                                    },
                                    child: Text(
                                      'FORGOT',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Regular',
                                        color: Colors.orange
                                      ),
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                            onPressed: () async{
                              if(!_isLoginInProcess) {
                                if (_formKey.currentState.validate()) {
                                  _changeLoginProgressStatus(true);
                                  FocusScope.of(context).unfocus();
                                  http.Response response = await networkCall
                                      .validateRequestViaLogin(
                                      emailController.text, passController.text);
                                  if (response.statusCode == 200) {
                                    _saveSessionId(response);
                                    _changeLoginProgressStatus(false);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()),
                                          (Route<dynamic> route) => false,
                                    );
                                  } else if (response.statusCode == 401) {
                                    _changeLoginProgressStatus(false);
                                    Utils.showAlertDialog(
                                        context, "Invalid Username or Password");
                                  }
                                }
                              }
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFB74D),
                                    Color(0xFFFFA726),
                                    Color(0xFFFB8C00),
                                    Color(0xFFF57C00),
                                    Color(0xFFEF6C00),
                                    Color(0xFFE65100),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontFamily: 'Roboto-Bold',
                                          fontSize: 15.0
                                      )
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  _isLoginInProcess?SizedBox(
                                      height:25.0,
                                      width: 25.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)):
                                  Image(
                                    image: AssetImage('images/right_arrow_icon.png'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _containerType?Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: RichText(
                        text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:"Don't have an account?  ",
                                  style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                  )
                              ),
                              TextSpan(
                                  text:"Sign up",
                                  recognizer: TapGestureRecognizer()..onTap=(){
                                    setState(() {
                                      url='https://www.themoviedb.org/account/signup';
                                      _containerType=false;
                                    });
                                  },
                                  style: TextStyle(
                                    fontFamily: 'Roboto-Bold',
                                    color: Colors.orange,
                                    fontSize: 15.0,
                                  )
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                ):
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0))
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height-50.0,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0))
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _containerType=true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 25,
                            child: WebView(
                              initialUrl: url,
                              javascriptMode: JavascriptMode.unrestricted,

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
