import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/tv_shows/ResultsTV.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/model_classes/tv_shows/TVShows.dart';
import 'package:movies_app/detail_page/DetailPage.dart';

enum CalledFrom{
  ONCHANGE,
  ONLOADMORE
}

class SearchTV extends StatefulWidget {
  @override
  _SearchTVState createState() => _SearchTVState();
}

class _SearchTVState extends State<SearchTV> {
  List<ResultsTV> searchResult=[];
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
    TVShows tvShows=await networkCall.fetchMoreSearchTVResultList(searchQuery, pageNo);
    if(tvShows.page!=null) {
      pageNo = tvShows.page + 1;
    }
    List<ResultsTV> tempList=tvShows.results.map((result)=>ResultsTV.fromJson(result.toJson())).toList();
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
                hintText: 'Search TV',
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
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                backgroundImage: ((searchResult[index].posterPath)!=null)?NetworkImage('https://image.tmdb.org/t/p/w154'+searchResult[index].posterPath):null,
              ),
              title: Text(
                searchResult[index].name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
              ),
              subtitle: Text(
                (searchResult[index].firstAirDate!=null)?searchResult[index].firstAirDate.split('-')[0]:'',
                style: TextStyle(
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
