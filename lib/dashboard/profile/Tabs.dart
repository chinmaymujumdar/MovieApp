import 'package:flutter/material.dart';
import 'package:movies_app/dashboard/profile/FavouriteList.dart';
import 'package:movies_app/dashboard/profile/WatchList.dart';

class Tabs extends StatefulWidget {
  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<Tabs> with TickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    _controller=TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 40.0,
              child: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(Colors.orange.value)),
                  insets: EdgeInsets.fromLTRB(50.0,0.0,50.0,0.0)
                ),
                unselectedLabelColor: Colors.grey,
                controller: _controller,
                labelColor: Color(Colors.white.value),
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelStyle: TextStyle(
                    fontFamily: 'Roboto_Light'
                ),
                labelStyle: TextStyle(
                    fontFamily: 'Roboto_Medium'
                ),
                tabs: <Widget>[
                  Text(
                    'FAVOURITES',
                  ),
                  Text(
                    'WATCH LIST',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  FavouriteList(),
                  WatchList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
