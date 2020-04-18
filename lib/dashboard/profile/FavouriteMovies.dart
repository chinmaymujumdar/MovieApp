import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/movie/Movie.dart';
import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/model_classes/tv_shows/TVShows.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/dashboard/GenreListCache.dart';
import 'package:movies_app/MovieType.dart';

class FavouriteMovies extends StatefulWidget {

  MovieType type;
  Key key;

  FavouriteMovies({@required this.type,@required this.key}):super(key:key);
  @override
  _FavouriteMoviesState createState() => _FavouriteMoviesState();
}

class _FavouriteMoviesState extends State<FavouriteMovies> {

  List<Results> _favMovieList=[];
  List<ResultsTV> _favtvList=[];
  int pageNo=1;
  NetworkCall _networkCall=NetworkCall();
  GenreListCache cache=GenreListCache();
  bool isFetching=true,reachedEnd=false;
  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    _getData();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        _getData();
      }
    });
    super.initState();
  }

  void _getData(){
    if(widget.type==MovieType.MOVIE&&!reachedEnd) {
      _getFavourites(pageNo);
    }else if(widget.type==MovieType.TV_SHOW&&!reachedEnd){
      _getFavouritesTv(pageNo);
    }else if(widget.type==MovieType.WATCH_LIST_MOVIE&&!reachedEnd){
      _getWatchMovies(pageNo);
    }else if(!reachedEnd){
      _getWatchTv(pageNo);
    }
  }

  void _getFavouritesTv(int page) async{
    TVShows movie=await _networkCall.getFavouritesTV(page);
    if(pageNo<movie.totalPages){
      pageNo=movie.page+1;
    }else{
      reachedEnd=true;
    }
    List<ResultsTV> result=movie.results.map((res)=>ResultsTV.fromJson(res.toJson())).toList();
    setState(() {
      isFetching=false;
      _favtvList.addAll(result);
    });
  }

  void _getFavourites(int page) async{
    Movie movie=await _networkCall.getFavourites(page);
    if(pageNo<movie.totalPages){
      pageNo=movie.page+1;
    }else{
      reachedEnd=true;
    }
    List<Results> result=movie.results.map((res)=>Results.fromJson(res.toJson())).toList();
    setState(() {
      isFetching=false;
      _favMovieList.addAll(result);
    });
  }

  void _getWatchMovies(int page) async{
    Movie movie=await _networkCall.getWatchMovies(page);
    if(pageNo<movie.totalPages){
      pageNo=movie.page+1;
    }else{
      reachedEnd=true;
    }
    List<Results> result=movie.results.map((res)=>Results.fromJson(res.toJson())).toList();
    setState(() {
      isFetching=false;
      _favMovieList.addAll(result);
    });
  }

  void _getWatchTv(int page) async{
    TVShows movie=await _networkCall.getWatchTV(page);
    if(pageNo<movie.totalPages){
      pageNo=movie.page+1;
    }else{
      reachedEnd=true;
    }
    List<ResultsTV> result=movie.results.map((res)=>ResultsTV.fromJson(res.toJson())).toList();
    setState(() {
      isFetching=false;
      _favtvList.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isFetching){
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }else {
      return widget.type == MovieType.MOVIE||widget.type==MovieType.WATCH_LIST_MOVIE
          ? _movieList(_favMovieList, context)
          : _tvList(_favtvList, context);
    }
  }

  Widget _movieList(List<Results> movie,BuildContext context){
    if(movie.length==0){
      return Expanded(child: Center(child: Text('No favourites',style: TextStyle(color: Colors.white),)));
    }else {
      return Flexible(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: movie.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _movieItem(movie[index], context);
          },
        ),
      );
    }
  }

  Widget _tvList(List<ResultsTV> movie,BuildContext context){
    if(movie.length==0){
      return Expanded(child: Center(child: Text('No favourites',style: TextStyle(fontFamily:'Roboto-Medium',color: Colors.white),)));
    }else {
      return Flexible(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: movie.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _tvItem(movie[index], context);
          },
        ),
      );
    }
  }

  Widget _movieItem(Results item,BuildContext context){
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                height: 200.0,
                placeholder: 'images/placeholder.png',
                image: 'https://image.tmdb.org/t/p/w154'+item.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily:'Roboto-Bold',
                        color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    '2h 43min',
                    style: TextStyle(
                        fontFamily:'Roboto-Regular',
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    cache.getFavMovieGenre(item.genreIds),
                    style: TextStyle(
                        fontFamily:'Roboto-Regular',
                        color: Colors.grey,
                        fontSize: 12.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star,color: Colors.orange,),
                      SizedBox(width: 5.0),
                      Text(
                        '8.1',
                        style: TextStyle(
                          fontFamily:'Roboto-Medium',
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        '/10',
                        style: TextStyle(
                          fontFamily:'Roboto-Medium',
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _tvItem(ResultsTV item,BuildContext context){
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                height: 200.0,
                placeholder: 'images/placeholder.png',
                image: 'https://image.tmdb.org/t/p/w154'+item.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily:'Roboto-Bold',
                        color: Colors.white,
                        fontSize: 20.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    '2h 43min',
                    style: TextStyle(
                        fontFamily:'Roboto-Regular',
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    cache.getFavMovieGenre(item.genreIds),
                    style: TextStyle(
                        fontFamily:'Roboto-Regular',
                        color: Colors.grey,
                        fontSize: 12.0,
                        letterSpacing: 0.5
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star,color: Colors.orange,),
                      SizedBox(width: 5.0),
                      Text(
                        '8.1',
                        style: TextStyle(
                          fontFamily:'Roboto-Medium',
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        '/10',
                        style: TextStyle(
                          fontFamily:'Roboto-Medium',
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
