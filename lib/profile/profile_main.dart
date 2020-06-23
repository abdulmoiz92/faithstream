import 'package:faithstream/profile/components/profile_header.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cntx,constraints) {
      return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.deepPurpleAccent,
                width: double.infinity,
                height: constraints.maxHeight * 0.3,
                child: Center(child: ProfileHeader()),
                ),
              SizedBox(height: constraints.maxHeight * 0.03),
            Center(child: Text("Menu", style: kTitleText.copyWith(fontSize: 22))),
            SizedBox(height: constraints.maxHeight * 0.005),
            Container(
              padding: EdgeInsets.only(left: constraints.maxWidth * 0.04, right: constraints.maxWidth * 0.04),
              width: double.infinity,
              height: constraints.maxHeight * 0.58,
              child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 16.0,
                    children: <Widget>[
                      buildProfileCard("Edit Profile", Icons.person,Colors.blue),
                      buildProfileCard("My Favourites",Icons.star,Colors.amber),
                      buildProfileCard("My Events",Icons.event,Colors.deepOrange),
                      buildProfileCard("Subscribed Channels",Icons.people,Colors.pink),
                      buildProfileCard("My Donations",Icons.pan_tool,Colors.red),
                      buildProfileCard("Logout",Icons.power_settings_new,Colors.indigo),
                    ],
              ),
            ),
            ],
      ),
         ),
       );
    });
  }
}