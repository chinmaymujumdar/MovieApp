import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/Dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xFF1a1a1a),
          accentColor: Colors.orange,
          scaffoldBackgroundColor: Color(0xFF1a1a1a)
      ),
      home: Dashboard()
    );
  }
}
