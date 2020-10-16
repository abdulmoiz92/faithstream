import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:faithstream/homescreen/home_screen.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'loginscreen/login_screen.dart';
import 'model/comment.dart';

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

BuildContext globalContext;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool appHasInternet = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      globalContext = context;
    });
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
      home: StreamBuilder(
          stream: Connectivity().onConnectivityChanged.asBroadcastStream(),
          builder: (context, snapshot) {
            SharedPrefHelper sph = new SharedPrefHelper();
            if (snapshot.hasData) if (snapshot.data ==
                    ConnectivityResult.mobile ||
                snapshot.data == ConnectivityResult.wifi) {
              Provider.of<PendingRequestProvider>(context)
                  .setConnectivityResult = snapshot.data;
              checkIfInternetIsConnected(context, sph);
            } else {
              Provider.of<PendingRequestProvider>(context)
                  .setConnectivityResult = snapshot.data;
              Provider.of<PendingRequestProvider>(context).setInternet = false;
            }
            return Homepage();
          }),
    );
  }

  Future<void> checkIfInternetIsConnected(
      BuildContext context, SharedPrefHelper sph) async {
    bool internetData = await DataConnectionChecker().hasConnection;
    if (internetData == true) {
      Provider.of<PendingRequestProvider>(context).setInternet = true;
      completePending(context, sph);
      checkFrontPostComment(sph);
    } else {
      Provider.of<PendingRequestProvider>(context).setInternet = false;
    }
  }

  Future<void> completePending(
      BuildContext context, SharedPrefHelper sph) async {
    await completePendingFavouriteRequests(context, sph).then((value) =>
        completePendingRemoveFavouriteRequests(context, sph)
            .then((value) => completePendingLikeRequests(context, sph))
            .then((value) => completePendingCommentRequests(context, sph)));
  }

  Future<void> checkFrontPostComment(SharedPrefHelper sph) {
    for (var b in Provider.of<BlogProvider>(context).allBlogs) {
      if (b.postComment != null) {
        if (b.postComment.commentId == null &&
            b.postComment.temopraryId != null) {
          getCommentForSinglePost(b.postId, sph);
        }
      }
    }
  }

  Future<void> getCommentForSinglePost(String id, SharedPrefHelper sph) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var commentData = await http
        .get("$baseAddress/api/Post/GetPostComments/$id", headers: {
      "Authorization": "Bearer ${prefs.getString(sph.user_token)}"
    });
    if (commentData.body.isNotEmpty) {
      var commentDataJson = json.decode(commentData.body);
      if (commentDataJson['data'] != null) {
        if (mounted)
          for (var c in commentDataJson['data']) {
            if (c['memberID'] == int.parse(prefs.getString(sph.member_id))) {
              Comment newComment = new Comment(
                  commentId: c['id'],
                  commentMemberId: c['memberID'],
                  authorImage: prefs.getString(sph.profile_image),
                  commentText: c['commentText'],
                  authorName: c['commentedBy'],
                  time: "${compareDate(c['dateCreated'])}");
              Provider.of<BlogProvider>(context).setPostComment(id, newComment);
            }
          }
      }
    }
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);
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

  @override
  bool get wantKeepAlive => true;
}
