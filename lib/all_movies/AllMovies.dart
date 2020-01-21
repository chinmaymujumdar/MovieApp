import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/movie/Movie.dart';
import 'package:movies_app/MovieType.dart';
import 'package:movies_app/model_classes/movie/UpcomingMovies.dart';
import 'package:movies_app/search/SearchPage.dart';
import 'package:movies_app/detail_page/DetailPage.dart';

class AllMovies extends StatefulWidget {

  MovieType movieType;

  AllMovies({@required this.movieType});

  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {

  List<Results> movieList=[];
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
      appBarTitle='Upcoming';
      fetchUpcomingMoviesList();
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
    Movie movie;
    if(widget.movieType==MovieType.POPULAR) {
      movie = await networkCall.fetchMorePopularMovies(pageNo);
    }else{
      movie = await networkCall.fetchMoreTopRatedMovies(pageNo);
    }
    if(movie.page!=null) {
      pageNo = movie.page + 1;
    }
    List<Results> tempList=movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    setState((){
      movieList.addAll(tempList);
    });
  }

  void fetchUpcomingMoviesList()async{
    UpcomingMovies movie=await networkCall.fetchMoreUpcomingMovieList(pageNo);
    if(movie.page!=null) {
      pageNo = movie.page + 1;
    }
    List<Results> tempList=movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    setState((){
      movieList.addAll(tempList);
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
                  builder: (context)=>SearchMovie(),
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
        children: List.generate(movieList.length, (index){
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>DetailPage(movieItem: movieList[index],)
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage('https://image.tmdb.org/t/p/w154'+movieList[index].posterPath),
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