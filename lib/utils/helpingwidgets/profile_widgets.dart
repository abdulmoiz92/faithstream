import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/helpingmethods/helping_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileTop extends StatelessWidget {
  final String image;

  EditProfileTop(this.image);

  @override
  Widget build(BuildContext context) {
      return LayoutBuilder(builder: (cntx,constraints) {
        return Container(
          margin: EdgeInsets.only(top: constraints.maxHeight * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(image: image == null ? AssetImage(
                        "assets/images/test.jpeg") : NetworkImage(image),
                        fit: BoxFit.fill)),),
              Container(
                child: Padding(padding: EdgeInsets.all(8.0),child: Text("Upload",style: TextStyle(color: Colors.red),),),
              ),
            ],
          ),
        );
      },);
    }
  }

  class EditProfileTextField extends StatelessWidget {
  final double margin;
  final double width;
  final IconData icon;
  final String text;
  final TextEditingController controller;

  EditProfileTextField(this.margin,this.width,this.icon,this.text,{@required this.controller});

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: margin),
        width: width,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            prefixIcon: Icon(icon, color: Color(0xFFBFBFC8),),
            labelText: text,
            labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEBEAEF)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEBEAEF)),
            ),
          ),
        ),
      );
  }
  }

  class SingleMyDonation extends StatelessWidget {
  BoxConstraints constraints;
  String profileImageUrl;
  String date;
  String details;
  String status;

  SingleMyDonation({this.constraints,this.profileImageUrl,this.date,this.details,this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: constraints.maxWidth * 0.85,
        height: constraints.maxHeight * 0.3,
        decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 35,
                  alignment: Alignment.centerLeft,
                  height: 35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: profileImageUrl == null ? AssetImage("assets/images/test.jpeg") : NetworkImage(profileImageUrl),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(50)),
                ),
                Spacer(),
                Container(
                    child: buildIconText(context, "${compareDate(date)} ago",
                        Icons.calendar_today, 4.0, Colors.white)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16,horizontal: 8.0),
                width: constraints.maxWidth * 0.85,
                child: Text(
                  details == null ? "No Details Available" : details,
                  style: TextStyle(color: Colors.white, fontSize: 15,height: 1.5),
                ),
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  }