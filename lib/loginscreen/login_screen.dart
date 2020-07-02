import 'dart:convert';

import 'package:faithstream/homescreen/home_screen.dart';
import 'dart:async';
import 'package:faithstream/loginscreen/components/login_textfeild.dart';
import 'package:faithstream/loginscreen/register_screen.dart';
import 'package:faithstream/styles/loginscreen_constants.dart';
import 'package:faithstream/utils/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPrefHelper sph = SharedPrefHelper();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: LayoutBuilder(builder: (cntx, constraints) {
            return Column(
              children: <Widget>[
                Image.asset("assets/images/loginbg.png",
                    width: double.infinity,
                    height: constraints.maxHeight * 0.45,
                    fit: BoxFit.cover),
                Container(
                  height: constraints.maxHeight * 0.55,
                  child: Column(
                    children: <Widget>[
                      Text("Welcome",
                          textAlign: TextAlign.center, style: kTitleText),
                      SizedBox(
                        height: constraints.maxHeight * 0.01,
                      ),
                      Text(
                        "Login to continue",
                        textAlign: TextAlign.center,
                        style: kLabelText,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      LoginTextField(
                        label: "Username/Email",
                        icon: Icons.mail_outline,
                        isObscure: false,
                        controller: usernameController,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      LoginTextField(
                        label: "Password",
                        icon: Icons.lock_outline,
                        isObscure: true,
                        controller: passwordController,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Container(
                        margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
                        width: constraints.maxWidth * 0.8,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (cntx) => RegisterScreen()));
                          },
                          child: Text(
                            "Create Account",
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
                              _authenticateUser(
                                  usernameController.text, passwordController.text);
                            },
                            child: Text("LOGIN",
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
        ),
      ),
    );
  }

  Future<void> _authenticateUser(String username, String password) async {
    final response = await http.post(
        "http://api.faithstreams.net/api/User/authenticate",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password
        }),
    );

    if (response.statusCode == 200) {
      if(json.decode(response.body)['data'] == null) {
        buildSnackBar(context, "Please Register Yourself First");
      } else {
        sph.setUserToken(json.decode(response.body)['data']['token']);
        sph.setUserId("${json.decode(response.body)['data']['id']}");
        sph.setIsLogin(true);
        sph.setMemberId("${json.decode(response.body)['data']['memberInfo']['id']}");
        Navigator.of(context).push(MaterialPageRoute(builder: (cntx) => HomeScreen()));
      }
      return true;
    } else {
      buildSnackBar(context, "Something Went Wrong");
      return false;
    }
  }
}
