import 'package:flutter/material.dart';
import 'package:movies_app/Constants.dart';
import 'package:movies_app/model_classes/tv_shows/Episodes.dart';
import 'package:movies_app/model_classes/tv_shows/Cast.dart';
import 'package:movies_app/network/NetworkCall.dart';

class EpisodeDetailPage extends StatelessWidget {

  final Episodes episode;
  final String runtime;
  final String showName;
  NetworkCall networkCall=NetworkCall();

  EpisodeDetailPage({@required this.episode,@required this.runtime,@required this.showName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Episode ${episode.episodeNumber}',
          style: TextStyle(
            fontFamily: 'Roboto-Bold'
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(kLandscapeImageBaseURL+episode.stillPath),
            ),
            SizedBox(
            height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$showName SN${episode.seasonNumber+1}',
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: Colors.white,
                        fontSize: 18.0,
                        letterSpacing: 1.5
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Ep ${episode.episodeNumber}'+' ',
                              style: TextStyle(
                                  fontFamily: 'Roboto-Bold',
                                  fontSize: 35.0,
                                  letterSpacing: 1.0
                              )
                          ),
                          TextSpan(
                              text: episode.name,
                              style: TextStyle(
                                  fontFamily: 'Roboto-Medium',
                                  fontSize: 32.0,
                                  letterSpacing: 2.0
                              )
                          ),
                        ]
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        runtime+' min'+'  |  ',
                        style: kEdpisodeTimeStyle,
                      ),
                      Text(
                        'TV-MA'+'  |  ',
                        style: kEdpisodeTimeStyle,
                      ),
                      Text(
                        episode.airDate==null?"":episode.airDate.split('-')[0],
                        style: kEdpisodeTimeStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Add to watchlist'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Roboto-Medium',
                        color: Colors.orange,
                        fontSize: 18.0,
                        letterSpacing: 1.0
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    episode.overview,
                    style: TextStyle(
                      fontFamily: 'Roboto-Light',
                      color: Colors.white,
                      fontSize: 15.0,
                      letterSpacing: 1.0,
                    ),
                  ),SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          'CAST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.orange,
                          thickness: 2.0,
                        ),
                      )
                    ],
                  ),
                  FutureBuilder<List<Cast>>(
                    future: networkCall.fetchCastList(episode.showId),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        List<Cast> list=snapshot.data;
                        return _castListView(list);
                      }else if(snapshot.hasError){
                        return Text(
                          '${snapshot.error}'
                        );
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _castListView(List<Cast> castList){
    return Container(
      height: 200.0,
      child: ListView.builder(
        itemCount: castList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 110.0,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(kPotraitImageBaseURL+castList[index].profilePath),
                    radius: 50.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    castList[index].name,
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    'as ${castList[index].character}',
                    style: TextStyle(
                      fontFamily: 'Roboto-Medium',
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
