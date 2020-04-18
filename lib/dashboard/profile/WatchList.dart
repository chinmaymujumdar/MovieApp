import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/profile/FavouriteMovies.dart';
import '../../MovieType.dart';

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  MovieType type=MovieType.WATCH_LIST_MOVIE;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  items: <MovieType>[MovieType.WATCH_LIST_MOVIE,MovieType.WATCH_LIST_TV_SHOW].map<DropdownMenuItem<MovieType>>((MovieType item){
                    return DropdownMenuItem<MovieType>(
                      value: item,
                      child: Text(
                        item==MovieType.WATCH_LIST_MOVIE?'Movies   ':'TV Shows   ',
                        style: TextStyle(
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
          type==MovieType.WATCH_LIST_MOVIE?FavouriteMovies(type: type,key: UniqueKey(),):FavouriteMovies(type: type,key: UniqueKey(),)
        ],
      ),
    );
  }
}
