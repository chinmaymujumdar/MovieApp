import 'package:flutter/material.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/model_classes/movie/VideosList.dart';
import 'package:movies_app/model_classes/movie/Video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movies_app/detail_page/season/SeasonDetailPage.dart';
import 'package:movies_app/Utils.dart';

class DetailPageTV extends StatefulWidget {

  final int tvid;

  DetailPageTV({@required this.tvid});

  @override
  _DetailPageTVState createState() => _DetailPageTVState();
}

class _DetailPageTVState extends State<DetailPageTV> {

  NetworkCall networkCall=NetworkCall();
  GenreListCache cache=GenreListCache();

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
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: networkCall.fetchTVDetail(widget.tvid),
          builder: (context,snapshot){
            if(snapshot.hasData){
              dynamic detail= snapshot.data;
              return _detailPage(detail,context);
            }else if(snapshot.hasError){
              return Text(
                  '${snapshot.error}'
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _detailPage(var item,BuildContext context){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            image: item['backdrop_path']==null?AssetImage('images/placeholder.png'):NetworkImage('https://image.tmdb.org/t/p/w500${item['backdrop_path'].toString()}'),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
            child: Row(
              children: <Widget>[
                Text(
                  getYear(item),
                  style: TextStyle(
                    fontFamily:'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  width: 25.0,
                ),
                Text(
                  item['number_of_seasons'].toString()+' Seasons',
                  style: TextStyle(
                    fontFamily:'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              item['name'],
              style: TextStyle(
                fontFamily: 'Roboto-Bold',
                  color: Colors.white,
                  fontSize: 40.0,
                  letterSpacing: 1.0
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
                    List<Video> list=getVideoList(item);
                    if(list.length!=0) {
                      showMenu(
                        color: Color(0xFF4d4d4d),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        context: context,
                        position: RelativeRect.fromLTRB(10.0, 310.0, 0.0, 10.0),
                        items: list.map((item) =>
                            PopupMenuItem<String>(
                              value: item.key,
                              child: GestureDetector(
                                onTap: () {
                                  _launchURL(item.key);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.videocam, color: Colors.orange,),
                                  title: Text(item.name,
                                    style: TextStyle(fontFamily:'Roboto-Regular',color: Colors.orange),),
                                ),
                              ),
                            )).toList(),
                      );
                    }
                  },
                  borderSide: BorderSide(color: Colors.orange,width: 2.0),

                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.play_arrow,
                        color: Colors.orange,
                      ),
                      Text(
                        'TRAILER',
                        style: TextStyle(
                            fontFamily:'Roboto-Regular',
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 1.0
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                OutlineButton(
                  onPressed: (){
                  },
                  borderSide: BorderSide(color: Colors.orange,width: 2.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.orange,
                      ),
                      Text(
                        'My List',
                        style: TextStyle(
                            fontFamily:'Roboto-Regular',
                            color: Colors.white,
                            fontSize: 14.0,
                            letterSpacing: 1.0
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              item['overview'],
              style: TextStyle(
                fontFamily:'Roboto-Light',
                color: Colors.white,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Row(
              children: getGenreList(item).map<Widget>((item)=>Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                      fontFamily:'Roboto-Bold',
                      color: Colors.white
                  ),
                ),
              )).toList(),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  item['vote_average'].toString(),
                  style: TextStyle(
                    fontFamily:'Roboto-Medium',
                    color: Colors.green,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 25.0,
                ),
                Text(
                  'Rate:',
                  style: TextStyle(
                    fontFamily:'Roboto-Medium',
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.thumb_up,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.thumb_down,
                  color: Colors.orange,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>SeasonDetailPage(
                    noOfSeason: item['number_of_seasons'],
                    tvid: widget.tvid,
                    name: item['name'],
                    runtime: getRuntime(item),
                  )
              ));
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  Divider(
                    color: Color(0xFF737373),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Episode Guide',
                        style: TextStyle(
                          fontFamily:'Roboto-Medium',
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Divider(
                    color: Color(0xFF737373),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10.0,right: 5.0),
                child: Text(
                  'MORE LIKE THIS',
                  style: TextStyle(
                    fontFamily:'Roboto-Bold',
                    color: Colors.white,
                    fontSize: 13.0,
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
          SizedBox(
            height: 15.0,
          ),
          FutureBuilder<List<ResultsTV>>(
            future: networkCall.fetchRecommendationsTVList(item['id']),
            builder: (context,snapshot){
              if(snapshot.hasData){
                List<ResultsTV> list= snapshot.data;
                return _movieGridView(list,context);
              }else if(snapshot.hasError){
                return Text(
                    '${snapshot.error}'
                );
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _movieGridView(List<ResultsTV> movieList, BuildContext context) {
    return Container(
      height: 300.0,
      padding: EdgeInsets.only(left: 10.0),
      child: GridView.count(
        padding: EdgeInsets.only(top: 5.0),
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.5,
        scrollDirection: Axis.horizontal,
        children: List.generate(movieList.length, (index){
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>DetailPageTV(tvid: movieList[index].id,)
                ));
              },
              child: Image(
                image: NetworkImage('https://image.tmdb.org/t/p/w154'+movieList[index].posterPath),
              ),
            ),
          );
        }
        ),
      ),
    );
  }

  String getYear(var item){
    if(item['status']=='Ended'){
      return item['first_air_date'].toString().split('-')[0]+'-'+item['last_air_date'].toString().split('-')[0];
    }else{
      return item['first_air_date'].toString().split('-')[0]+'-';
    }
  }

  List<String> getGenreList(var item){
    List<dynamic> genre=item['genres'];
    List<int> ids=[];
    for(int i=0;i<genre.length;i++){
      ids.add(genre[i]['id']);
    }
    return cache.getTvGenreList(ids);
  }

  List<Video> getVideoList(var item){
    VideosList video=VideosList.fromJson(item['videos']);
    List<Video> videoList=[];
    videoList.addAll(video.results.map((result)=>Video.fromJson(result.toJson())).toList());
    return videoList;
  }

  String getRuntime(var item){
    List<dynamic> list=item['episode_run_time'];
    return list[0].toString();
  }
}
