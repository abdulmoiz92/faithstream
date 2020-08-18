import 'dart:async';

import 'package:faithstream/homescreen/components/blog_posts.dart';
import 'package:faithstream/homescreen/home_screen.dart';
import 'package:faithstream/singlepost/components/single_post_content.dart';
import 'package:faithstream/singlepost/single_post.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginscreen/login_screen.dart';
import 'loginscreen/register_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => PendingRequestProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => BlogProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        sliderTheme: SliderTheme.of(context).copyWith(
          inactiveTrackColor: Colors.grey,
          thumbColor: Colors.white,
          activeTrackColor: Colors.white,
          overlayColor: Colors.white,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLogin;
  Widget page;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: (MediaQuery.of(context).size.height * 1),
      child: page,
    ));
  }

  Future<SharedPreferences> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    setState(() {
      isLogin = prefs.getBool(sph.is_login);
      page = isLogin == true ? HomeScreen() : LoginScreen();
    });
  }
}
