import 'dart:convert';

import 'package:faithstream/model/category.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingwidgets/findchannel_widgets.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/category_card.dart';

class FindChannelsScreen extends StatefulWidget {
  var contex;
  @override
  _findChannelsScreenState createState() => _findChannelsScreenState();
}

class _findChannelsScreenState extends State<FindChannelsScreen> with AutomaticKeepAliveClientMixin {
  String userToken;
  List<Category> allCategories = [];
  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(builder: (cntx,constraints) {
     return Container(
       margin: EdgeInsets.only(top: constraints.maxHeight * 0.03),
       width: double.infinity,
       height: constraints.maxHeight * 1,
       child: Column(
         children: <Widget>[
           Center(
             child: Container(
               padding: EdgeInsets.only(left: constraints.maxWidth * 0.02,top: constraints.maxHeight * 0.025,bottom: constraints.maxHeight * 0.025),
               color: Colors.lightBlue.withOpacity(0.3),
               width: constraints.maxWidth * 0.9,
               height: constraints.maxHeight * 0.15,
               child: FindChannelTop(),
             ),
           ),
           Center(
             child: Container(
               margin: EdgeInsets.only(top: constraints.maxHeight * 0.03),
               width: constraints.maxWidth * 0.9,
               height: constraints.maxHeight * 0.75,
               child: CategoryCard(categoriesList: allCategories,),
             ),
           ),
         ],
       ),
     );
   },
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
      });
    if(mounted)
    checkInternet(context,futureFunction: getCategory());
  }

  Future<void> getCategory() async {
    var CategoryData = await http.get(
        "http://api.faithstreams.net/api/Common/GetCategories",
        headers: {"Authorization": "Bearer $userToken"});

    var CategoryDataJson = json.decode(CategoryData.body);

    for (var c in CategoryDataJson['data']) {
      if (mounted)
        setState(() {
          Category newCategory = new Category(iconUrl: c['icon'],categoryName: c['name'],categoryId: c['id'],numOfSteps: c['numOfSteps']);
          allCategories.add(newCategory);
        });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}