import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/movie/MovieHorizontalList.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/MovieType.dart';

class Movies extends StatefulWidget {
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  NetworkCall networkCall=NetworkCall();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          MovieHorizontalList(
            title: 'Popular',
            apiResult: networkCall.fetchPopularMovieList(1),
            movieType: MovieType.POPULAR,
          ),
          SizedBox(
            height: 10.0,
          ),
          MovieHorizontalList(
            title: 'Top Rated',
            apiResult: networkCall.fetchTopRatedMovieList(1),
            movieType: MovieType.TOP_RATED,
          ),
          SizedBox(
            height: 10.0,
          ),
          MovieHorizontalList(
            title: 'Popular',
            apiResult: networkCall.fetchUpcomingMovieList(1),
            movieType: MovieType.UPCOMING,
          ),
        ],
      ),
    );
  }
}
