import 'dart:io';
import 'dart:typed_data';

import 'package:faithstream/model/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

const kTitleText =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35);
const kLabelText = TextStyle(color: Color(0xFFC9CAD1), fontSize: 15);

const baseAddress = "http://api112.streamomedia.com";

GestureDetector buildIconText(BuildContext context, String text, IconData icon,
    double padding, Color color,
    {Color iconColor, Function onTap}) {
  return GestureDetector(
    onTap: onTap == null ? () {} : onTap,
    child: RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Icon(
                icon,
                color: iconColor == null ? color : iconColor,
                size: 16,
              ),
            ),
          ),
          TextSpan(text: text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    ),
  );
}

Column buildIconColumnText(BuildContext context, String text, IconData icon,
    double padding, Color color,
    {Color iconColor, Function onTap,double size}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        onTap: onTap == null ? () {} : onTap,
        child: Icon(
          icon,
          color: iconColor == null ? color : iconColor,
          size: size,
        ),
      ),
      if(text != null)
      Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Text(text, style: TextStyle(color: color, fontSize: 12))),
    ],
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

Future<bool> hasInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on Exception catch (_) {
    print("not Connected");
    return false;
  }
}

void checkInternet(BuildContext context,
    {Future<void> futureFunction, void simpleFunction, Function noNet}) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print(result);
      futureFunction == null ? simpleFunction : futureFunction;
    }
  } on SocketException catch (_) {
    noNet();
  }
}

void buildSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
  Scaffold.of(context).showSnackBar(snackBar);
}

Row buildAvatarText(
    BuildContext context,
    String image,
    String title,
    double height,
    Widget optionalWidgetOne,
    Widget optionalWidgetTwo,
    Color color,
    {String id,
    Function onTap,
    Uint8List authorImageBytes,
    bool internet}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: image != null && internet == true
                  ? NetworkImage(image)
                  : image == null || authorImageBytes == null
                      ? AssetImage("assets/images/test.jpeg")
                      : MemoryImage(authorImageBytes),
              fit: BoxFit.fill,
            ),
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
                title != null
                    ? GestureDetector(
                        onTap: onTap,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      )
                    : Text(""),
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

LayoutBuilder buildProfileCard(String text, IconData icon, Color iconColor,
    {Function onTap}) {
  return LayoutBuilder(builder: (cntx, constraints) {
    return Container(
        width: constraints.maxWidth * 0.9,
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          title: Text(
            text,
            textAlign: TextAlign.left,
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 12),
        ));
  });
}

Row buildChannelContent(BuildContext context, String logo, String title,
    int index, List<Channel> allChannels) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: logo == null
                  ? AssetImage("assets/images/test.jpeg")
                  : NetworkImage(logo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title != null
                    ? Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    : Text(""),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: allChannels[index].prefrence == null
                      ? Container()
                      : buildTextWithIcon(context, Icons.category,
                          "${allChannels[index].prefrence}", 3.0, Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /*,*/
                      buildTextWithIcon(
                          context,
                          Icons.videocam,
                          "${allChannels[index].numOfVideos}",
                          3.0,
                          Colors.white),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("|", style: TextStyle(color: Colors.white)),
                      ),
                      buildTextWithIcon(
                          context,
                          Icons.people,
                          "${allChannels[index].numOfSubscribers}",
                          3.0,
                          Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

RichText buildTextWithIcon(BuildContext context, IconData icon, String text,
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
              size: 20,
            ),
          ),
        ),
        TextSpan(
            text: text == "null" ? "" : text,
            style: TextStyle(color: color, fontSize: 15)),
      ],
    ),
  );
}
