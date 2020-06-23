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
      {@required this.authorImage,@required this.authorName, @required this.authorSubscribers, @required this.postViews, @required this.title, @required this.postedDate, @required this.postDescription});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (cnt, constraints) {
      return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: constraints.maxHeight * 0.05,
                horizontal: constraints.maxWidth * 0.05),
            child: Column(
                children: <Widget>[
                buildAvatarText(
                context,
                authorImage,
                authorName,
                constraints.maxHeight * 0.01,
                buildIconText(context, authorSubscribers, Icons.person, 2.0,
                Colors.blueGrey),
                postViews != null ? buildIconText(
                context, postViews, Icons.remove_red_eye, 2.0, Colors.blueGrey) : null,
            Colors.black),
        SizedBox(height: constraints.maxHeight * 0.05),
        Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                title,
                style: kTitleText.copyWith(fontSize: 25),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.04,
            ),
            Container(
                width: double.infinity,
                child: Text(
                  "$postedDate",
                  style: kLabelText,
                  textAlign: TextAlign.left,
                )),
            SizedBox(
              height: constraints.maxHeight * 0.04,
            ),
            Container(
                width: constraints.maxWidth * 0.9,
                child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \n It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                  style: kLabelText.copyWith(
                      wordSpacing:
                      constraints.maxWidth * 0.01,
                      height: 1.8,
                      color: Color(0xFF9BA0AB)),
                  textAlign: TextAlign.left,
                )),
          ],
        ),
        ],
      ),)
      ,
      );
    });
  }

}