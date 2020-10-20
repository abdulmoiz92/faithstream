import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/comment.dart';
import 'package:faithstream/model/trending_posts.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/helpers/blog_helper.dart';
import 'package:faithstream/utils/ProviderUtils/pending_provider.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'your_blogs.dart';

class BlogPostsScreen extends StatefulWidget {
  @override
  BlogPostsScreenState createState() => BlogPostsScreenState();
}

class BlogPostsScreenState extends State<BlogPostsScreen>
    with AutomaticKeepAliveClientMixin<BlogPostsScreen> {
  var internet;

  SharedPrefHelper sph = SharedPrefHelper();

  List<Blog> allBlogs = [];
  final List<TPost> allTrendingPosts = [];
  List<Comment> commentsList = [];

  List<int> ChannelIds;
  String userId;
  String userToken;
  String memberId;
  String profileImage;
  Blog newBlog = new Blog();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(builder: (cntx, constraints) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.27),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: Provider.of<BlogProvider>(context).blogsLength > 1
              ? YourBlogs(
                  Provider.of<BlogProvider>(context).getAllBlogs,
                  memberId,
                  userToken,
                  profileImage: profileImage,
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<SharedPreferences> getData() async {
    if (Provider.of<PendingRequestProvider>(globalContext).connectivityResult ==
        ConnectivityResult.wifi ||
        Provider.of<PendingRequestProvider>(globalContext).connectivityResult ==
            ConnectivityResult.mobile) {
      internet = await DataConnectionChecker().hasConnection;
      setState(() {});
    }
    if (Provider.of<PendingRequestProvider>(globalContext).connectivityResult ==
        ConnectivityResult.none) {
      internet = false;
      setState(() {});
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPrefHelper sph = SharedPrefHelper();
    if (mounted)
      setState(() {
        userId = prefs.getString(sph.user_id);
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
        profileImage = prefs.getString(sph.profile_image);
      });
    Provider.of<BlogProvider>(globalContext).resetBlog = [];
    internet == true
        ? BlogHelper().getVideos(
        mounted: mounted,
        memberId: memberId,
        newBlog: newBlog,
        userToken: userToken,
        setState: setState)
        : await BlogHelper().getVideosFromPrefs(
        mounted: mounted,
        internet: internet,
        memberId: memberId,
        userToken: userToken,
        newBlog: newBlog,
        setState: setState);
  }


  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
