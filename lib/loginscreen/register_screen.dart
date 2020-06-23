import 'package:faithstream/loginscreen/login_screen.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/login_textfeild.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (cntx, constraints) {
        return Column(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).padding.top +
                    constraints.maxHeight * 0.03),
            Container(
              height: constraints.maxHeight * 0.9,
              child: Column(
                children: <Widget>[
                  Text("Register",
                      textAlign: TextAlign.center, style: kTitleText),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  Text(
                    "Register yourself here",
                    textAlign: TextAlign.center,
                    style: kLabelText,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  LoginTextField(
                    label: "First Name",
                    icon: Icons.person_outline,
                    isObscure: false,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  LoginTextField(
                    label: "Last Name",
                    icon: Icons.person_outline,
                    isObscure: false,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  LoginTextField(
                    label: "Username/Email",
                    icon: Icons.mail_outline,
                    isObscure: false,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  LoginTextField(
                    label: "Password",
                    icon: Icons.lock_outline,
                    isObscure: true,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  LoginTextField(
                    label: "Confirm Password",
                    icon: Icons.lock_open,
                    isObscure: true,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Container(
                    margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
                    width: constraints.maxWidth * 0.8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF9B601),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: constraints.maxWidth * 0.7,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
