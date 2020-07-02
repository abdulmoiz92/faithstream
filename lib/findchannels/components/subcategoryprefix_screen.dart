import 'dart:convert';

import 'package:faithstream/findchannels/components/channel_screen.dart';
import 'package:faithstream/model/category.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryPrefixesScreen extends StatefulWidget {
  int catId;

  SubCategoryPrefixesScreen({@required this.catId});

  @override
  _SubCategoryPrefixesScreenState createState() => _SubCategoryPrefixesScreenState();
}

class _SubCategoryPrefixesScreenState extends State<SubCategoryPrefixesScreen> {
  String userToken;

  List<Category> allSubCategories = [];

  String groupName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          "Channels List",
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (cntx,constraints) {
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
                  height: constraints.maxHeight * 0.08,
                  child: RichText(text: TextSpan(text: "",children: <TextSpan>[
                    TextSpan(text: "Step 3: ",style: kTitleText.copyWith(fontSize: 13)),
                    TextSpan(text: "Select $groupName",style: TextStyle(fontSize: 13,color: Colors.black87))
                  ]),),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: constraints.maxHeight * 0.015),
                  width: constraints.maxWidth * 0.9,
                  height: constraints.maxHeight * 0.858,
                  child: ListView.builder(itemCount: allSubCategories.length,itemBuilder: (cntx,index){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Divider(),
                        GestureDetector(
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (cntx) => ChannelScreen(subCategoryPrefixesId: allSubCategories[index].categoryId,))); },
                          child: Container(
                            width: constraints.maxWidth * 0.9,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.03),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if(mounted) Image.network("${allSubCategories[index].iconUrl}",width: 50,height: 30,),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Text("${allSubCategories[index].categoryName}"),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios,size: 14,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
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
      });
    checkInternet(context,futureFunction: getSubCategory());
  }

  Future<void> getSubCategory() async {
    var CategoryData = await http.get(
        "http://api.faithstreams.net/api/Common/GetSubCategoryPrefixes/${widget.catId}",
        headers: {"Authorization": "Bearer $userToken"});

    var CategoryDataJson = json.decode(CategoryData.body);

    if(CategoryDataJson['data'] != null)
      for (var c in CategoryDataJson['data']) {
        if(mounted)
          setState(() {
            groupName = c['groupName'];
          });
        if (mounted)
          setState(() {
            Category newSubCategory = new Category(iconUrl: c['icon'],categoryName: c['name'],categoryId: c['id']);
            allSubCategories.add(newSubCategory);
          });
      }
  }
}