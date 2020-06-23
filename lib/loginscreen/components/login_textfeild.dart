import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final isObscure;
  TextEditingController controller;

  LoginTextField({@required this.label, @required this.icon, @required this.isObscure, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraints) {
      return Container(
        width: constraints.maxWidth * 0.8,
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            suffixIcon: Icon(icon, color: Color(0xFFBFBFC8),),
            labelText: label,
            labelStyle: TextStyle(color: Color(0xFAC9CAD1)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEBEAEF)),
            ),
          ),
        ),
      );
    },
    );
  }

}