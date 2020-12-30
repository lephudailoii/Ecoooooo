import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Share {
  Future<String> getshare(String key) async{
    SharedPreferences shared = await SharedPreferences.getInstance();
  }
}