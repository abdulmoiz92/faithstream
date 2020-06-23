import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

const kTitleText =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35);
const kLabelText = TextStyle(color: Color(0xFFC9CAD1), fontSize: 15);

RichText buildIconText(BuildContext context, String text, IconData icon,
    double padding, Color color) {
  return RichText(
    text: TextSpan(
      children: [
        WidgetSpan(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
        ),
        TextSpan(text: text, style: TextStyle(color: color, fontSize: 12)),
      ],
    ),
  );
}

Row buildHeading(
    BuildContext context, Widget firstWidget, Widget secondWidget) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      firstWidget,
      Spacer(),
      secondWidget,
    ],
  );
}

void buildSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
  Scaffold.of(context).showSnackBar(snackBar);
}

Future<SharedPreferences> addPref() async {
  return await SharedPreferences.getInstance();
}

Row buildAvatarText(
    BuildContext context,
    String image,
    String title,
    double height,
    Widget optionalWidgetOne,
    Widget optionalWidgetTwo,
    Color color) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
            image: image == null
                ? AssetImage("assets/images/test.jpeg")
                : NetworkImage(image),
            fit: BoxFit.fill,
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                if (optionalWidgetOne != null && optionalWidgetTwo != null)
                  SizedBox(height: height),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /*,*/
                    if (optionalWidgetOne != null)
                      optionalWidgetOne,
                    if (optionalWidgetOne != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: optionalWidgetTwo == null
                            ? null
                            : optionalWidgetTwo,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

LayoutBuilder buildProfileCard(String text,IconData icon,Color iconColor) {
  return LayoutBuilder(builder: (cntx,constraints){
    return Container(
        width: constraints.maxWidth * 0.2,
        height: constraints.maxHeight * 0.1,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: iconColor,size: 40,),
              SizedBox(height: constraints.maxHeight * 0.06),
              Text(text),
            ],
          ),
        ));
  });
}
