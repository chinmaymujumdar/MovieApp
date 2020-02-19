import 'package:flutter/material.dart';
import 'package:movies_app/model_classes/tv_shows/Season.dart';
import 'package:movies_app/model_classes/tv_shows/Episodes.dart';
import 'package:movies_app/network/NetworkCall.dart';
import 'package:movies_app/detail_page/episode/EpisodeDetailPage.dart';

class SeasonDetailPage extends StatefulWidget {

  final int noOfSeason;
  final int tvid;
  final String name;
  final String runtime;

  SeasonDetailPage({@required this.noOfSeason,@required this.tvid,@required this.name,@required this.runtime});

  @override
  _SeasonDetailPageState createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {

  int seasonNo=0,noOfEpisodes=0;
  Season season;
  bool visibility=false;
  List<Episodes> episodeList=[];
  NetworkCall networkCall=NetworkCall();
  
  List<int> getSeasonList(){
    List<int> seasonList=[];
    for(int i=0;i<widget.noOfSeason;i++){
      seasonList.add(i);
    }
    return seasonList;
  }

  @override
  void initState() {
    super.initState();
    fetchSeasonDetails();
  }

  void fetchSeasonDetails() async{
    Season season=await networkCall.fetchSeasonDetails(widget.tvid, seasonNo+1);
    setState(() {
      if(season!=null) {
        visibility=true;
        episodeList.clear();
        episodeList.addAll(season.episodes);
        noOfEpisodes=episodeList.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
                      child: DropdownButton<int>(
                        value: seasonNo,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.orange,
                        ),
                        isDense: true,
                        items: getSeasonList().map<DropdownMenuItem<int>>((int item){
                          return DropdownMenuItem<int>(
                            value: item,
                            child: Text(
                              'Season ${item+1}   ',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int no){
                          setState(() {
                            seasonNo=no;
                            visibility=false;
                          });
                          fetchSeasonDetails();
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  noOfEpisodes.toString()+' episodes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
          visibility?Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: episodeList.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>EpisodeDetailPage(
                        episode: episodeList[index],
                        runtime: widget.runtime,
                        showName: widget.name,
                      )
                    ));
                  },
                  child: ListTile(
                    leading: Text(
                        (seasonNo+1).toString()+'.'+(index+1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    title: Text(
                      episodeList[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          episodeList[index].voteAverage.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          episodeList[index].airDate==null?'':episodeList[index].airDate,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.orange,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              separatorBuilder: (context,index){
                return Divider(color: Colors.grey,);
              },
            ),
          ):Expanded(child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}
