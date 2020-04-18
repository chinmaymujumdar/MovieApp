import 'package:flutter/material.dart';
import 'package:movies_app/MovieType.dart';
import 'FavouriteMovies.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  
  MovieType type=MovieType.MOVIE;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                ),
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: DropdownButtonHideUnderline(
              child: Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Color(0xFF4d4d4d)
                ),
                child: DropdownButton<MovieType>(
                  value: type,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.orange,
                  ),
                  isDense: true,
                  items: <MovieType>[MovieType.MOVIE,MovieType.TV_SHOW].map<DropdownMenuItem<MovieType>>((MovieType item){
                    return DropdownMenuItem<MovieType>(
                      value: item,
                      child: Text(
                        item==MovieType.MOVIE?'Movies   ':'TV Shows   ',
                        style: TextStyle(
                            fontFamily: 'Roboto_Black',
                            color: Colors.white
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (MovieType no){
                    setState(() {
                      type=no;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          type==MovieType.MOVIE?FavouriteMovies(type: type,key: UniqueKey(),):FavouriteMovies(type: type,key: UniqueKey(),)
        ],
      ),
    );
  }
}
