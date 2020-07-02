import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:faithstream/findchannels/find_channels.dart';
import 'package:faithstream/homescreen/components/blog_posts.dart';
import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/profile/profile_main.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/trendingscreen/trending_posts.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPrefHelper sph = SharedPrefHelper();
  String userId;
  String userToken;
  String memberId;
  String profileImage;

//  final List<TPost> _allTrendingPosts = [];

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
        iconTheme: new IconThemeData(color: Colors.black87),
        title: Text(
          "FaithStream",
          style: TextStyle(color: Colors.black87, fontSize: 15),
        ),
        backgroundColor: Colors.white);
    final mediaQuery = MediaQuery.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: appBar,
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          labelColor: Colors.red,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.trending_up)),
            Tab(icon: Icon(Icons.photo_library)),
            Tab(
                icon: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: profileImage == null ? AssetImage("assets/images/test.jpeg") : NetworkImage(profileImage),
                          fit: BoxFit.fill)),
                )),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: TabBarView(
            children: <Widget>[
              BlogPostsScreen(),
              TrendingPostsScreen(),
              FindChannelsScreen(),
              ProfileNavigation(),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userId = prefs.getString(sph.user_id);
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
      });
    if(mounted)
    checkInternet(context,futureFunction: getUser(),noNet: () {buildSnackBar(context, "Please Check Your Internet");});
  }


  Future<void> getUser() async {
    var userData = await http.get(
        "http://api.faithstreams.net/api/User/GetUserData/$userId",
        headers: {"Authorization": "Bearer $userToken"});

    var userDataJson = json.decode(userData.body);

    if (mounted)
      if(userDataJson['data'] == null) buildSnackBar(context, "Server Is Busy");
      setState(() {
        profileImage = userDataJson['data']['memberInfo']['profileImage'];
      });
  }
}
/* -------------------------------- Drawer ---------------------------------
Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(image: AssetImage("assets/images/model.png"),fit: BoxFit.fill)),
                  ),
                  SizedBox(height: 15,),
                  Text("Mohammed Owais Khan Kas",style: kTitleText.copyWith(color: Colors.white,fontSize: 18),),
                  SizedBox(height: 10,),
                  Text("imranmoiz936@gmail.com",style: kLabelText.copyWith(color: Colors.white,fontSize: 12),),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
      ------------------------------------- End Drawer -------------------------------------------
 */
