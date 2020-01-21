import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/movie/Video.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerPopupMenu extends StatelessWidget {

  final List<Video> videoList;

  TrailerPopupMenu({@required this.videoList});

  void _launchURL(String key) async{
    String url='https://www.youtube.com/watch?v=$key';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String key){
        _launchURL(key);
      },
      itemBuilder: (context)=>videoList.map((item)=> PopupMenuItem<String>(
        value: item.key,
        child: ListTile(
          leading: Icon(Icons.videocam,color: Colors.white,),
          title: Text(item.name,style: TextStyle(color: Colors.white),),
        ),
      )).toList(),
    );
  }
}
