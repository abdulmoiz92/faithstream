import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final String user_token = "user_token";
  final String user_id = "user_id";
  final String is_login = "is_login";
  final String member_id = "member_id";
  final String profile_image = "profile_image";
  final String first_name = "first_name";
  final String last_name = "last_name";

  Future<void> setUserToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.user_token, token);
  }

  Future<void> setUserId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.user_id, id);
  }

  Future<void> setIsLogin(bool islogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(is_login, islogin);
  }

  Future<void> setMemberId(String memberId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(member_id, memberId);
  }

  Future<void> setProfileImage(String profileImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(profile_image, profileImage);
  }

  Future<void> setFirstName(String firstName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(first_name, firstName);
  }

  Future<void> setLastName(String lastName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(last_name, lastName);
  }
}