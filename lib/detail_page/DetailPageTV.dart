import 'package:flutter/material.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';

class DetailPageTV extends StatefulWidget {

  final int tvid;

  DetailPageTV({@required this.tvid});

  @override
  _DetailPageTVState createState() => _DetailPageTVState();
}

class _DetailPageTVState extends State<DetailPageTV> {

  List<String> list=['Action','Adventure','Comedy'];
  NetworkCall networkCall=NetworkCall();

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
            image: NetworkImage('https://image.tmdb.org/t/p/w500/hbgPoI0GBrXJfGjYNV2fMQU0xou.jpg'),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
            child: Row(
              children: <Widget>[
                Text(
                  '2017 - 2019',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  '2 seasons',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700
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
              'Marvel\'s The Punisher',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
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
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
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
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
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
              'After the murder of his family, Marine veteran Frank Castle becomes the vigilante known as "The Punisher," with only one goal in mind: to avenge them.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
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
              children: list.map<Widget>((item)=>Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  item,
                  style: TextStyle(
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
                  '7.8',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(
                  width: 25.0,
                ),
                Text(
                  'Rate:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700
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
          Container(
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
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
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
          SizedBox(
            height: 15.0,
          ),
          FutureBuilder<List<ResultsTV>>(
            future: networkCall.fetchOnAirTVShowList(1),
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
}
