import 'dart:async';

import 'package:faithstream/findchannels/find_channels.dart';
import 'package:faithstream/homescreen/components/blog_posts.dart';
import 'package:faithstream/profile/profile_main.dart';
import 'package:faithstream/trendingscreen/trending_posts.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
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
        profileImage = prefs.getString(sph.profile_image);
      });
  }

  @override
  void dispose() {
    super.dispose();
  }
}