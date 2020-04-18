import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/movie/Results.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/movie/Movie.dart';
import 'package:movies_app/detail_page/DetailPage.dart';

enum CalledFrom{
  ONCHANGE,
  ONLOADMORE
}

class SearchMovie extends StatefulWidget {
  @override
  _SearchMovieState createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {

  List<Results> searchResult=[];
  NetworkCall networkCall=NetworkCall();
  String searchQuery;
  int pageNo=1;
  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        fetchSearchResults(CalledFrom.ONLOADMORE);
      }
    });
  }

  void fetchSearchResults(CalledFrom calledFrom) async{
    Movie movie=await networkCall.fetchMoreSearchResultList(searchQuery, pageNo);
    if(movie.page!=null) {
      pageNo = movie.page + 1;
    }
    List<Results> tempList=movie.results.map((result)=>Results.fromJson(result.toJson())).toList();
    setState(() {
      if(calledFrom==CalledFrom.ONCHANGE){
        searchResult.clear();
        searchResult.addAll(tempList);
      }else{
        searchResult.addAll(tempList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            style: TextStyle(
              color: Colors.white,
            ),
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(12.0),
              filled: true,
              fillColor: Color(0xFF4d4d4d),
              hintText: 'Search Movie',
              hintStyle: TextStyle(
                color: Color(0xFF999999),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
            ),
            onChanged: (queryTxt){
              pageNo=1;
              searchQuery=queryTxt;
              fetchSearchResults(CalledFrom.ONCHANGE);
            },
          ),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: searchResult.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>DetailPage(movieItem: searchResult[index],)
              ));
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                backgroundImage: ((searchResult[index].posterPath)!=null)?NetworkImage('https://image.tmdb.org/t/p/w154'+searchResult[index].posterPath):null,
              ),
              title: Text(
                searchResult[index].title,
                style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
              subtitle: Text(
                  (searchResult[index].releaseDate!=null)?searchResult[index].releaseDate.split('-')[0]:'',
                style: TextStyle(
                    fontFamily: 'Roboto-Light',
                    color: Colors.grey,
                    fontSize: 15.0
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}