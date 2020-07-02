import 'package:faithstream/homescreen/home_screen.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginscreen/login_screen.dart';
import 'loginscreen/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: (
        MediaQuery.of(context).size.height * 1),
        child: page,
    )
    );
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