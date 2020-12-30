import 'package:e_shop/Config/share.dart';
import 'package:e_shop/Config/share.dart';
import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemCounter extends ChangeNotifier{
  
  int _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  int get count => _counter;
  Future<void> displayResult() async{
  int  _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  await Future.delayed(const Duration(microseconds: 100),(){notifyListeners();});
  }
}