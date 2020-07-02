import 'package:faithstream/model/blog.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePostContent extends StatelessWidget {
  final String authorImage;
  final String authorName;
  final String authorSubscribers;
  final String postViews;
  final String title;
  final String postedDate;
  final String postDescription;

  SinglePostContent(
      {@required this.authorImage,
      @required this.authorName,
      @required this.authorSubscribers,
      @required this.postViews,
      @required this.title,
      @required this.postedDate,
      @required this.postDescription});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cnt, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.05,
                  horizontal: constraints.maxWidth * 0.05),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: kTitleText.copyWith(fontSize: 15)),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Text("$postViews Views | 3 Likes"),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.thumb_up),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.share),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Divider(thickness: 0.5, color: Colors.black26),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * 0.02,
                  horizontal: constraints.maxHeight * 0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: AssetImage("assets/images/test.jpeg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(authorName,style: kTitleText.copyWith(fontSize: 15)),
                        SizedBox(height: constraints.maxHeight * 0.01,),
                        Text("5 Subscribers",textAlign: TextAlign.left,style: kLabelText.copyWith(fontSize: 13)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(thickness: 0.5, color: Colors.black26),
            SizedBox(height: constraints.maxHeight * 0.05),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: constraints.maxWidth * 0.6,
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                  Image.asset("assets/images/facebook.png",width: 32,height: 32,),
                  Spacer(),
                  Image.asset("assets/images/twitter.png",width: 32,height: 32,),
                  Spacer(),
                  Image.asset("assets/images/google-plus.png",width: 32,height: 32,),
                  Spacer(),
                  Image.asset("assets/images/linkedin.png",width: 32,height: 32,),
                ],),
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.08),
            Container(margin: EdgeInsets.only(left: constraints.maxWidth * 0.04),width: double.infinity,child: Text("Comments",textAlign: TextAlign.left,style: kTitleText.copyWith(fontSize: 20),)),
            SizedBox(height: constraints.maxHeight * 0.04),
            Container(
              width: double.infinity,
              height: constraints.maxHeight * 0.5,
              child: ListView.builder(itemCount: 2,itemBuilder: (cntx,index){
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: constraints.maxWidth * 0.9,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: AssetImage("assets/images/test.jpeg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Author Name",style: kTitleText.copyWith(fontSize: 13)),
                              SizedBox(height: constraints.maxHeight * 0.01,),
                              Text("Comment Text",style: kLabelText.copyWith(fontSize: 11,color: Colors.black87)),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.favorite_border,size: 18,color: Colors.grey,)
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
