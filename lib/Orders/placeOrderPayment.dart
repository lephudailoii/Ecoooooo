
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/dashboard.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/dashboardcard.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final String paymentdetail;
  final   DashBoardModel model;
  final double total;

  PaymentPage({Key key,this.addressId,this.totalAmount,this.paymentdetail,this.model,this.total}): super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  double finaltotal;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettinggsAndroid;

  var initializationSettinggsIOS;
  var initializationSettinggs;


  void shownotification() async {
    await demonotification();
  }

  Future<void> demonotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "channelID", "channelname", "channeldes", importance: Importance.max,
        priority: Priority.high,
        ticker: 'test ticker');
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Dat Hang Thanh Cong',
        'Xin chuc mung ban da dat hang thanh cong , chung toi se kiem tra va giao hang cho ban som nhat',
        platformChannelSpecifics, payload: 'test payload');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettinggsAndroid =
    new AndroidInitializationSettings('icon_app');
    initializationSettinggsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettinggs = new InitializationSettings(
        android: initializationSettinggsAndroid,
        iOS: initializationSettinggsIOS);
    flutterLocalNotificationsPlugin.initialize(
        initializationSettinggs, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("OK"),
                )
              ],
            )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: () => addOrderDetails(),
                child: Text("PLace Order", style: TextStyle(fontSize: 30.0),),
              )
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences.getStringList(
          EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: widget.paymentdetail,
      EcommerceApp.orderTime: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      EcommerceApp.isSuccess: false,
      EcommerceApp.step: "1",

    }).whenComplete(() =>
    {
      emptyCartNow()
    });
    writeDashBoard(({ EcommerceApp.totalAmount: widget.totalAmount,
    }));
  }

  emptyCartNow() {
    List tempList = EcommerceApp.sharedPreferences.getStringList(
        EcommerceApp.userCartList);
    deletecart(tempList);
    EcommerceApp.sharedPreferences.setStringList(
        EcommerceApp.userCartList, ["garbageValue"]);
    List tempList2 = EcommerceApp.sharedPreferences.getStringList(
        EcommerceApp.userCartList);
    Firestore.instance.collection("users")
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
    EcommerceApp.userCartList: tempList2});
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
    shownotification();
    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }

  deletecart(List<String> list) async {
    for (
    var id in list
    ) {
      EcommerceApp.firestore.collection("users")
          .document(
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .collection(EcommerceApp.userCartList)
          .document(id)
          .delete();
    }
  }

  Future writeDashBoard(Map<String, dynamic>data) async {
    int month = DateTime
        .now()
        .month;
    int year = DateTime
        .now()
        .year;
    String smonth = month.toString();
    String syear = year.toString();
    String a = smonth + syear;
    await EcommerceApp.firestore.collection(EcommerceApp.collectiondashBoard)
        .document(a)
        .setData(data);
  }

  Future writePoint() async {
    String pointnows = EcommerceApp.sharedPreferences.getString(
        EcommerceApp.Point);
    double pointnow = double.tryParse(pointnows);
    double cash = widget.totalAmount;
    pointnow = cash + pointnow;
    if (pointnow >= 1000000) {
      await EcommerceApp.firestore.collection('users')
          .document(
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .updateData({EcommerceApp.userLevel: 'Friendly Customer'});
    }
    String pointnew = pointnow.toString();
    await EcommerceApp.firestore.collection('users')
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({EcommerceApp.Point: pointnew});
  }


  Future writeOrderDetailsForAdmin(Map<String, dynamic>data) async {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionOrders)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .setData(data);
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .setData(data);
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionHistoryUser)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .setData(data);
    await EcommerceApp.firestore.collection(EcommerceApp.collectionHistoryAdmin)
        .document(
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .setData(data);
  }


}
