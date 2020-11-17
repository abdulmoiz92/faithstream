import 'package:flutter/material.dart';

class EditProfileTop extends StatelessWidget {
  final String image;

  EditProfileTop(this.image);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cntx, constraints) {
        return Container(
          margin: EdgeInsets.only(top: constraints.maxHeight * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: image == null
                            ? AssetImage("assets/images/test.jpeg")
                            : NetworkImage(image),
                        fit: BoxFit.fill)),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Upload",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final double margin;
  final double width;
  final IconData icon;
  final String text;
  final TextEditingController controller;

  EditProfileTextField(this.margin, this.width, this.icon, this.text,
      {@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          prefixIcon: Icon(
            icon,
            color: Color(0xFFBFBFC8),
          ),
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
