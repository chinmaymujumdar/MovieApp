import 'package:flutter/material.dart';
import 'package:movies_app/Constants.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/MovieType.dart';
import 'package:movies_app/all_movies/AllTVShows.dart';
import 'package:movies_app/detail_page/DetailPageTV.dart';

class ViewPager extends StatefulWidget {
  @override
  _ViewPagerState createState() => _ViewPagerState();
}

class _ViewPagerState extends State<ViewPager> {

  PageController _pageController;
  int currentPage=0;
  NetworkCall networkCall = NetworkCall();
  GenreListCache cache=GenreListCache();

  @override
  void initState() {
    super.initState();
    _pageController=PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.9
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=> AllTVShows(movieType: MovieType.TV_ON_AIR,)
            ));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0,2.0,12.0,2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Shows On Air',
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
        Container(
          height: 220.0,
          child: FutureBuilder<List<ResultsTV>>(
            future: networkCall.fetchOnAirTVShowList(1),
            builder: (context,snapshot){
              if(snapshot.hasData){
                List<ResultsTV> list= snapshot.data;
                return _pageViewBuilder(list);
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
      ],
    );
  }

  Widget _pageViewBuilder(List<ResultsTV> list){
    return PageView.builder(
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      pageSnapping: true,
      onPageChanged: (index){
        setState(() {
          currentPage=index;
        });
      },
      itemBuilder: (context,index){
        return _itemBuilder(list[index]);
      },
    );
  }

  Widget _itemBuilder(ResultsTV item){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>DetailPageTV(tvid: item.id,)
          ));
        },
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage('https://image.tmdb.org/t/p/w500'+item.backdropPath),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 35.0,
              left: 10.0,
              child: Container(
                width: 350.0,
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15.0,
              left: 10.0,
              child: Container(
                width: 380.0,
                child: Text(
                  cache.getTVGenre(item.genreIds).replaceAll('/',' . '),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFb3b3b3),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
