import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movies_app/model_classes/movie/Video.dart';
import 'package:movies_app/model_classes/movie/VideosList.dart';
import 'package:movies_app/DatabaseHelper.dart';

class DetailPage extends StatefulWidget {

  final Results movieItem;
  GenreListCache cache=GenreListCache();
  NetworkCall networkCall=NetworkCall();

  DetailPage({@required this.movieItem});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  String runtime='        ';
  List<Video> videoList=[];
  final globalKey = GlobalKey<ScaffoldState>();
  DatabaseHelper db=DatabaseHelper();
  bool _favourite=false;
  bool _watchlist=false;

  @override
  void initState() {
    super.initState();
    fetchRunTime();
    fetchFavourites();
  }

  void fetchRunTime() async{
    dynamic detail=await widget.networkCall.fetchRunTime(widget.movieItem.id);
    int time=detail['runtime'];
    VideosList video=VideosList.fromJson(detail['videos']);
    setState(() {
      videoList.addAll(video.results.map((result)=>Video.fromJson(result.toJson())).toList());
      runtime=Utils.getTimeInHrMin(time);
    });
  }
  
  void fetchFavourites() async{
    dynamic fav= await widget.networkCall.checkForFavWatch(widget.movieItem.id);
    setState(() {
      _favourite=fav['favorite'];
      _watchlist=fav['watchlist'];
    });
  }

  void _launchURL(String key) async{
    String url='https://www.youtube.com/watch?v=$key';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }

  void insertFavourite() async{
    bool fav=await widget.networkCall.addToFavourite(widget.movieItem.id, !_favourite);
    setState(() {
      if(fav) {
        _favourite = !_favourite;
      }
    });
  }

  void insertWatchlist() async{
    bool watch=await widget.networkCall.addToWatchlist(widget.movieItem.id, !_watchlist);
    setState(() {
      if(watch) {
        _watchlist = !_watchlist;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Image(
                          image: ((widget.movieItem.posterPath)!=null)?NetworkImage('https://image.tmdb.org/t/p/w154'+widget.movieItem.posterPath)
                              :AssetImage('images/placeholder.png'),
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    widget.movieItem.title,
                    style: TextStyle(
                      fontFamily:'Roboto-Black',
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.cache.getGenre(widget.movieItem.genreIds).replaceAll('/', ' . '),
                    style: TextStyle(
                        fontFamily:'Roboto-Medium',
                        color: Colors.white,
                        fontSize: 13.0,
                        letterSpacing: 1.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EclipseText(
                        text: widget.movieItem.releaseDate!=null?widget.movieItem.releaseDate.split('-')[0]:'    ',
                      ),
                      DotPlusSpace(),
                      EclipseText(
                        text: widget.movieItem.voteAverage.toString(),
                      ),
                      DotPlusSpace(),
                      EclipseText(
                        text: runtime,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconText(
                        icon: _watchlist?Icons.check:Icons.add,
                        text: 'Watch List',
                        onPress: insertWatchlist,
                      ),
                      IconText(
                        icon: Icons.thumb_up,
                        text: 'Rate',
                      ),
                      IconText(
                        icon: Icons.share,
                        text: 'Share',
                      ),
                      IconText(
                        icon: _favourite?Icons.favorite:Icons.favorite_border,
                        text: 'Favourite',
                        color: Colors.red,
                        onPress: insertFavourite,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      widget.movieItem.overview,
                      style: TextStyle(
                          fontFamily:'Roboto-Light',
                          color: Colors.white,
                          fontSize: 15.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15.0,right: 5.0),
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
                    height: 25.0,
                  ),
                  FutureBuilder<List<Results>>(
                    future: widget.networkCall.fetchRecommendationsMovieList(widget.movieItem.id),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        List<Results> list= snapshot.data;
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
              Positioned(
                top: 206.0,
                left: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: (){
                    if(videoList.length!=0) {
                      showMenu(
                        color: Color(0xFF4d4d4d),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        context: context,
                        position: RelativeRect.fromLTRB(10.0, 206, 0.0, 10.0),
                        items: videoList.map((item) =>
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
                                    style: TextStyle(color: Colors.orange),),
                                ),
                              ),
                            )).toList(),
                      );
                    }else{
                      globalKey.currentState.showSnackBar(SnackBar(
                        content: Text("No trailer available"),
                      ));
                    }
                  },
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.orange,
                    size: 50.0,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget _movieGridView(List<Results> movieList, BuildContext context) {
  return Container(
    height: 300.0,
    padding: EdgeInsets.only(left: 15.0),
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
                  builder: (context)=>DetailPage(movieItem: movieList[index],)
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

class DotPlusSpace extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 7.0,
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 3.0,
        ),
        SizedBox(
          width: 7.0,
        ),
      ],
    );
  }
}

class EclipseText extends StatelessWidget {

  final String text;

  EclipseText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0,5.0,20.0,5.0),
      decoration: BoxDecoration(
        color: Color(0xFF4d4d4d),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily:'Roboto-Medium',
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
