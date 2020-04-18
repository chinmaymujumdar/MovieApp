import 'package:flutter/material.dart';

class IconText extends StatelessWidget {

  final String text;
  final IconData icon;
  final Function onPress;
  final Color color;

  IconText({@required this.text,@required this.icon,this.onPress,this.color=Colors.orange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 20.0,
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily:'Roboto-Regular',
              color: Colors.white,
              fontSize: 12.0,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}