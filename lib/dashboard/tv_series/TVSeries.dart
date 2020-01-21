import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/tv_series/ViewPager.dart';
import 'TVShowHorizontalList.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/MovieType.dart';

class TVSeries extends StatefulWidget {
  @override
  _TVSeriesState createState() => _TVSeriesState();
}

class _TVSeriesState extends State<TVSeries> {

  NetworkCall networkCall=NetworkCall();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ViewPager(),
          SizedBox(
            height: 10.0,
          ),
          TVShowHorizontalList(
            title: 'Popular',
            apiResult: networkCall.fetchPopularTVShowList(1),
            movieType: MovieType.POPULAR,
          ),
          SizedBox(
            height: 10.0,
          ),
          TVShowHorizontalList(
            title: 'Top Rated',
            apiResult: networkCall.fetchTopRatedTVShowList(1),
            movieType: MovieType.TOP_RATED,
          ),
        ],
      ),
    );
  }
}
