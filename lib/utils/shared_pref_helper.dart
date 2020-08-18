import 'dart:convert';

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
  var blog_posts = "blog_posts";
  var favourite_posts = "favourite_posts";
  var pendinglikes_requests = "pendinglikes_requests";
  var pendingfavourite_requests = "pendingfavourites_requests";
  var pendingremovefavourite_requests = "pendingremovefavourites_requests";
  var pendingcomment_requests = "pendingcomment_requests";

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

  savePosts(String key,value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  readPosts(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString(key) == null)
    return null;
    return json.decode(prefs.getString(key));
  }

  clearKeyFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> setPendingRequests(List<void> pendingRequests) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

  }

}