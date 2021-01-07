
import 'package:flutter/foundation.dart';

class SaleChanger extends ChangeNotifier{
  int _counter =0 ;
  int get count => _counter;
  displayResult(int v){
    _counter =v;
    notifyListeners();
  }
}