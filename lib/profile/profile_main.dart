import 'dart:convert';

import 'package:faithstream/homescreen/components/blog_posts.dart';
import 'package:faithstream/utils/custom_modal.dart' as bs;
import 'package:faithstream/loginscreen/login_screen.dart';
import 'package:faithstream/profile/event_followed.dart';
import 'package:faithstream/profile/favourite_posts.dart';
import 'package:faithstream/profile/components/profile_header.dart';
import 'package:faithstream/profile/edit_profile.dart';
import 'package:faithstream/profile/mydonations.dart';
import 'package:faithstream/profile/purchased_items.dart';
import 'package:faithstream/profile/subscribed_channels.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileNavigation extends StatefulWidget {
  @override
  _ProfileNavigationState createState() => _ProfileNavigationState();
}

class _ProfileNavigationState extends State<ProfileNavigation> {
  String userId;
  String userToken;
  String memberId;
  String userProfileImage;
  String userName = "";
  String userEmail = "";
  String userFirstName = "";
  String userLastName = "";
  String userPhoneNumber;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (cntx, constraints) {
      return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: constraints.maxHeight * 0.2,
                margin: EdgeInsets.only(
                    left: constraints.maxWidth * 0.03,
                    top: constraints.maxHeight * 0.02),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileHeader(
                      image: userProfileImage,
                      name: userName,
                      email: userEmail,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.01,
                    right: constraints.maxWidth * 0.02),
                width: double.infinity,
                height: constraints.maxHeight * 0.77,
                child: ListView(
                  children: [
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard("Edit Profile", Icons.person, Colors.blue,
                        onTap: () {
                      bs.showModalBottomSheet(context: context, builder: (cntx) => EditProfile(
                        userToken: userToken,
                        userId: userId,
                        memberId: memberId,
                        image: userProfileImage,
                        firstName: userFirstName,
                        lastName: userLastName,
                        userEmail: userEmail,
                        userPhone: userPhoneNumber,
                      ),barrierColor: Colors.white.withOpacity(0),isScrollControlled: true,enableDrag: false,isDismissible: false);
                    }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard("My Favourites", Icons.star, Colors.amber,
                        onTap: () {
                      bs.showModalBottomSheet(context: context, builder: (cntx) => FavouritePosts(),isDismissible: false,enableDrag: false,isScrollControlled: true,barrierColor: Colors.white.withOpacity(0));
                    }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard(
                        "My Events", Icons.event, Colors.deepOrange, onTap: () {
                          bs.showModalBottomSheet(context: context, builder: (cntx) => EventsFollowed(),barrierColor: Colors.white.withOpacity(0),isScrollControlled: true,enableDrag: false,isDismissible: false);
                    }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard(
                        "Subscribed Channels", Icons.people, Colors.pink,
                        onTap: () {
                          bs.showModalBottomSheet(context: context, builder: (cntx) => SubscribedChannels(),isDismissible: false,enableDrag: false,isScrollControlled: true,barrierColor: Colors.white.withOpacity(0));
                    }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard(
                        "Purchased Items", Icons.local_grocery_store, Colors.green,
                        onTap: () {
                          bs.showModalBottomSheet(context: context, builder: (cntx) => PurchasedItems(),barrierColor: Colors.white.withOpacity(0),isScrollControlled: true,enableDrag: false,isDismissible: false);
                        }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard("My Donations", Icons.pan_tool, Colors.red,
                        onTap: () {
                      bs.showModalBottomSheet(context: context, builder: (cntx) => MyDonations(),isDismissible: false,enableDrag: false,isScrollControlled: true,barrierColor: Colors.white.withOpacity(0));
                    }),
                    Divider(
                      color: Colors.black12,
                    ),
                    buildProfileCard(
                        "Logout", Icons.power_settings_new, Colors.indigo,
                        onTap: () {
                      logout(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<SharedPreferences> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await deleteCacheDir().then((_) => print("done delete")).then((_) => prefs
        .clear()
        .then((_) => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (cntx) => LoginScreen()))));
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
    if (ModalRoute.of(context).isCurrent)
      checkInternet(context, futureFunction: getUser());
  }

  Future<void> getUser() async {
    var userData = await http.get(
        "$baseAddress/api/User/GetUserData/$userId",
        headers: {"Authorization": "Bearer $userToken"});

    var userDataJson = json.decode(userData.body);

    if (mounted)
      setState(() {
        userProfileImage = userDataJson['data']['memberInfo']['profileImage'];
        userName = "${userDataJson['data']['firstName']}";
        userEmail = "${userDataJson['data']['emailAddress']}";
        userFirstName = userDataJson['data']['firstName'];
        userLastName = userDataJson['data']['lastName'];
        userPhoneNumber = userDataJson['data']['memberInfo']['phone'];
      });
  }
}