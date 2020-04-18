import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/movie/Movies.dart';
import 'package:movies_app/dashboard/tv_series/TVSeries.dart';
import 'package:movies_app/search/SearchPage.dart';
import 'package:movies_app/search/SearchTV.dart';
import 'package:movies_app/dashboard/profile/ProfileScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int _selectedIndex=0;
  List<Widget> _widgetList=<Widget>[
    Movies(),
    TVSeries(),
    ProfileScreen()
  ];
  
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex<=1?AppBar(
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>_selectedIndex==0?SearchMovie():SearchTV()
            ));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color(0xFF4d4d4d),
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: double.infinity,
            child: Text(
              _selectedIndex==0?'Search Movies':'Search TV',
              style: TextStyle(
                fontFamily: 'Roboto-Light',
                color:Color(0xFF999999),
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ):null,
      body: _widgetList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_movies,
              ),
              title: Text(
                  'Movies',
                style: TextStyle(
                  fontFamily: 'Roboto-Medium'
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.live_tv,
              ),
              title: Text(
                  'TV Series',
                style: TextStyle(
                    fontFamily: 'Roboto-Medium'
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              title: Text(
                'Me',
                style: TextStyle(
                    fontFamily: 'Roboto-Medium'
                ),
              ),
            )
          ],
        backgroundColor: Color(0xFF262626),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Color(0xFFa6a6a6),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
