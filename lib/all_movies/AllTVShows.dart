import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/tv_shows/TVShows.dart';
import 'package:movies_app/MovieType.dart';
import 'package:movies_app/search/SearchTV.dart';

class AllTVShows extends StatefulWidget {

  MovieType movieType;

  AllTVShows({@required this.movieType});
  
  @override
  _AllTVShowsState createState() => _AllTVShowsState();
}

class _AllTVShowsState extends State<AllTVShows> {
  
  List<ResultsTV> tvShowList=[];
  NetworkCall networkCall=NetworkCall();
  int pageNo=1;
  ScrollController _scrollController=ScrollController();
  String appBarTitle;

  @override
  void initState() {
    super.initState();
    if(widget.movieType==MovieType.POPULAR){
      appBarTitle='Popular';
      fetchMoviesList();
    }else if(widget.movieType==MovieType.TOP_RATED){
      appBarTitle='Top Rated';
      fetchMoviesList();
    }else{
      appBarTitle='Shows On Air';
      fetchMoviesList();
    }
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        fetchMoviesList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchMoviesList()async{
    TVShows tvShows;
    if(widget.movieType==MovieType.POPULAR) {
      tvShows = await networkCall.fetchMorePopularTVShowList(pageNo);
    }else if(widget.movieType==MovieType.TOP_RATED){
      tvShows = await networkCall.fetchMoreTopRatedTVShowList(pageNo);
    }else{
      tvShows=await networkCall.fetchMoreOnAirTVShowList(pageNo);
    }
    if(tvShows.page!=null) {
      pageNo = tvShows.page + 1;
    }
    List<ResultsTV> tempList=tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
    setState((){
      tvShowList.addAll(tempList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              appBarTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>SearchTV(),
                ));
              },
              child: Icon(
                Icons.search,
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 5.0),
        crossAxisCount: 3,
        childAspectRatio: 0.67,
        controller: _scrollController,
        children: List.generate(tvShowList.length, (index){
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: (){
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage('https://image.tmdb.org/t/p/w154'+tvShowList[index].posterPath),
                ),
              ),
            ),
          );
        }
        ),
      ),
    );
  }
}
