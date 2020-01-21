import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/all_movies/AllMovies.dart';
import 'package:movies_app/MovieType.dart';
import 'package:movies_app/Constants.dart';
import 'package:movies_app/all_movies/AllTVShows.dart';
import 'package:movies_app/detail_page/DetailPageTV.dart';

class TVShowHorizontalList extends StatelessWidget {

  final GenreListCache genreListCache=GenreListCache();
  final String title;
  final Future<List<ResultsTV>> apiResult;
  final MovieType movieType;

  TVShowHorizontalList({@required this.title,@required this.apiResult,@required this.movieType});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=> AllTVShows(movieType: movieType,)
            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: kTitleStyle,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'All',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.orange,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<ResultsTV>>(
          future: apiResult,
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<ResultsTV> list= snapshot.data;
              return _movieListView(list,context);
            }else if(snapshot.hasError){
              return Text(
                  '${snapshot.error}'
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }

  Widget _movieListView(List<ResultsTV> data,BuildContext context){
    return Container(
      height: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context,index){
          return _listItem(data[index],context);
        },
      ),
    );
  }

  Widget _listItem(ResultsTV item,BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 3.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>DetailPageTV()
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage('https://image.tmdb.org/t/p/w154'+item.posterPath),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              width: 145.0,
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              width: 145.0,
              child: Text(
                genreListCache.getTVGenre(item.genreIds),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF4d4d4d),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
