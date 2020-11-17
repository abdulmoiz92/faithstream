import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PurchasedItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Purchased Items",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.black87,
              labelColor: Colors.red,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.videocam),
                  text: "Videos",
                ),
                Tab(
                  icon: Icon(Icons.event),
                  text: "Events",
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                child: TabBarView(
                  children: <Widget>[
                    Container(),
                    Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}