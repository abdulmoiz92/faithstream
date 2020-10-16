import 'dart:convert';

import 'package:faithstream/model/userDonations.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/profile_widgets.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyDonations extends StatefulWidget {
  @override
  _MyDonationsState createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations> {
  String userId;
  String userToken;
  String memberId;

  List<UserDonations> myDonationsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "My Donations",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
              width: double.infinity,
              height: constraints.maxHeight * 1,
              child: ListView.builder(
                  itemCount: myDonationsList.length,
                  itemBuilder: (cntx, index) {
                    return SingleMyDonation(
                        constraints: constraints,
                        date: myDonationsList[index].date,
                        details: myDonationsList[index].details,
                        profileImageUrl: myDonationsList[index].profileImage,
                        status: "completed");
                  }));
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
        userId = prefs.getString(sph.user_id);
        userToken = prefs.getString(sph.user_token);
        memberId = prefs.getString(sph.member_id);
      });
    checkInternet(context, futureFunction: getDonations());
  }

  Future<void> getDonations() async {
    var myDonationData = await http.get(
        "$baseAddress/api/Member/GetMemberDonationHistory/$memberId",
        headers: {"Authorization": "Bearer $userToken"});

    print("$memberId");
    print("$userToken");

    if (myDonationData.body.isNotEmpty) {
      var myDonationDataJson = json.decode(myDonationData.body);
      if (myDonationDataJson['data'] != null) {
        for (var u in myDonationDataJson['data']) {
          if (myDonationDataJson['data'] == []) continue;

          var channelData = await http.get(
              "$baseAddress/api/Channel/GetChannelByChannelID/${u['channelID']}",
              headers: {"Authorization": "Bearer $userToken"});

          var channelDataJson = json.decode(channelData.body);

          setState(() {
            UserDonations newUserDonation = new UserDonations(
                u['dateCreated'],
                u['details'],
                u['amount'],
                u['channelID'],
                channelDataJson['data']['logo']);
            myDonationsList.add(newUserDonation);
          });
        }
        ;
      }
    }
  }
}
