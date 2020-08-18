import 'dart:convert';

import 'package:faithstream/homescreen/components/your_blogs.dart';
import 'package:faithstream/model/blog.dart';
import 'package:faithstream/model/channel.dart';
import 'package:faithstream/model/donation.dart';
import 'package:faithstream/searchscreens/components/search_suggestions.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/ProviderUtils/blog_provider.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  String memberId;
  String userToken;
  bool seearchMode = false;
  bool showChannels = false;
  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: seearchMode == false
            ? Text("Search",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black87, fontSize: 18))
            : Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      autofocus: true,
                      autocorrect: true,
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: "Type To Search",
                          labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                ],
              ),
        actions: <Widget>[
          if (seearchMode == true)
            IconButton(
              icon: Icon(Icons.clear),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  seearchMode = false;
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.red,
            onPressed: seearchMode == false
                ? () {
                    setState(() {
                      seearchMode = true;
                    });
                  }
                : () {
                    if (seearchMode == true &&
                        searchController.text.isNotEmpty) {
                      getPostSearchResults(searchController.text);
                      getChannelSearchResults(searchController.text);
                    }
                    setState(() {
                      seearchMode = false;
                    });
                  },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (cntx, constraints) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: <Widget>[
                        Switch(
                          value: showChannels,
                          onChanged: (value) {
                            setState(() {
                              showChannels = value;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.red,
                          inactiveThumbColor: Colors.white,
                          activeTrackColor: Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                              showChannels == false ? "Posts" : "Channels"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.85,
                    margin: EdgeInsets.only(top: 8.0),
                    child: SearchSuggestions(
                      searchResults: showChannels == true
                          ? null
                          : Provider.of<BlogProvider>(context).searchBlogs,
                      channelSearchResults: showChannels == false ? null : Provider.of<BlogProvider>(context).searchChannels,
                      userToken: userToken,
                      memberId: memberId,
                    )),
              ],
            ),
          );
        },
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
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
      });
    Provider.of<BlogProvider>(context).resetSearchBlog();
  }

  Future<void> getChannelSearchResults(String query) async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Member/GetChannelsByKeyword/$query/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        Provider.of<BlogProvider>(context).resetSearchBlog();
        for (var u in channelDataJson['data']) {
          Provider.of<BlogProvider>(context).resetChannelSearch();
          if (channelDataJson['data'] == []) continue;
          Channel newChannel = new Channel(id: u['id'], channelName: u['name']);
          Provider.of<BlogProvider>(context).addChannelSearch = newChannel;
          setState(() {});
        }
      }
    }
  }

  Future<void> getPostSearchResults(String query) async {
    var channelData = await http.get(
        "http://api.faithstreams.net/api/Member/SearchContents/$query",
        headers: {"Authorization": "Bearer $userToken"});

    var isFavouriteData = await http.get(
        "http://api.faithstreams.net/api/Post/GetFavoriteTimeLine/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (channelData.body.isNotEmpty) {
      var channelDataJson = json.decode(channelData.body);
      if (channelDataJson['data'] != null) {
        Provider.of<BlogProvider>(context).resetSearchBlog();
        for (var u in channelDataJson['data']) {
          if (channelDataJson['data'] == []) continue;

          var eventData;

          if (u['postType'] == "Event")
            eventData = await http.get(
                "http://api.faithstreams.net/api/Member/GetEventByID/${u['event']['id']}",
                headers: {"Authorization": "Bearer $userToken"});

          var postData = u;

          Blog newBlog = new Blog(
              postId: null,
              postType: null,
              videoUrl: null,
              image: null,
              title: null,
              author: null,
              authorImage: null,
              date: null,
              time: null,
              likes: null,
              views: null,
              subscribers: null);

          if (mounted)
            setState(() {
              List<Donation> donnations = [];

              if (u['denom'] != null) {
                if (u['denom'] != [])
                  for (var d in u['denom']) {
                    Donation newDonation = new Donation(
                        id: d['id'].toString(),
                        channelId: d['channelID'].toString(),
                        denomAmount: d['denomAmount'],
                        denomDescription: d['denomDescription']);
                    donnations.add(newDonation);
                  }
              }

              if (u['postType'] == "Event")
                newBlog = new Blog(
                    postId: postData['id'],
                    postType: postData['postType'],
                    videoUrl: postData['event']['video'] != null
                        ? postData['event']['video']['url']
                        : postData['event']['video'],
                    image: postData['event']['image'],
                    title: postData['title'],
                    authorId: postData['authorID'],
                    author: postData['authorName'],
                    authorImage: postData['authorImage'],
                    date: postData['dateCreated'],
                    time: "${compareDate(postData['dateCreated'])} ago",
                    likes: "${postData['likesCount']}",
                    views: postData['event']['video'] != null
                        ? "${postData['event']['video']['numOfViews']}"
                        : null,
                    subscribers: "${postData['numOfSubscribers']}",
                    eventId: postData['event']['id'],
                    eventLocation: postData['event']['location'],
                    eventTime:
                        "${DateFormat.jm().format(DateTime.parse(postData['event']['startTime']))} | ${DateFormat.jm().format(DateTime.parse(postData['event']['endTime']))} , ${DateFormat.MMMd().format(DateTime.parse(postData['event']['postSchedule']))}",
                    isDonationRequired: postData['isDonationRequire'],
                    donations: donnations,
                    isTicketAvailable: postData['event']
                        ['isTicketPurchaseRequired'],
                    isPast: json.decode(eventData.body)['data'] == null
                        ? true
                        : json.decode(eventData.body)['data']['isPast']);
              if (u['postType'] == "Video")
                newBlog = new Blog(
                    postId: postData['id'],
                    postType: postData['postType'],
                    videoUrl: postData['video']['url'],
                    image: postData['video']['thumbnail'],
                    title: postData['title'],
                    authorId: postData['authorID'],
                    author: postData['authorName'],
                    authorImage: postData['authorImage'],
                    date: postData['dateCreated'],
                    time: "${compareDate(postData['dateCreated'])} ago",
                    likes: "${postData['video']['numOfLikes']}",
                    views: "${postData['video']['numOfViews']}",
                    subscribers: "${postData['numOfSubscribers']}",
                    videoDuration: "",
                    donations: donnations,
                    isDonationRequired: postData['isDonationRequire'],
                    isPaidVideo: postData['video']['isPaidContent'],
                    isPurchased: postData['video']['isPurchased'],
                    videoPrice: postData['video']['price'] == null
                        ? null
                        : double.parse(postData['video']['price']),
                    freeVideoLength: postData['video']['freeVideoLength']);

              if (u['postType'] == "Image")
                newBlog = new Blog(
                  postId: postData['id'],
                  postType: postData['postType'],
                  videoUrl: null,
                  image: postData['image']['url'],
                  title: postData['title'],
                  authorId: postData['authorID'],
                  author: postData['authorName'],
                  authorImage: postData['authorImage'],
                  date: postData['dateCreated'],
                  time: "${compareDate(postData['dateCreated'])} ago",
                  likes: "${postData['likesCount']}",
                  views: null,
                  subscribers: "${postData['numOfSubscribers']}",
                  isDonationRequired: postData['isDonationRequire'],
                  donations: donnations,
                );

              var isFavouritejsonData = jsonDecode(isFavouriteData.body);
              if (isFavouriteData
                  .body.isNotEmpty) if (isFavouritejsonData['data'] != null)
                for (var fv in isFavouritejsonData['data']) {
                  if (fv['id'] == postData['id']) {
                    newBlog.setIsFavourite = 1;
                  }
                }

              if (u['postLikes'] != [])
                for (var il in u['postLikes']) {
                  if (il['memberID'] == memberId) {
                    newBlog.setIsLiked = 1;
                  }
                }
              donnations = [];
            });
          Provider.of<BlogProvider>(context).addSearchBlog = newBlog;
          setState(() {});
        }
      }
    }
  }
}
