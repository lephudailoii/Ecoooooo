
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
  var initializationSettinggsAndroid ;
  var initializationSettinggsIOS;
  var initializationSettinggs;


  
  void shownotification() async{
    await demonotification();

  }
  Future<void> demonotification()async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails("channelID","channelname","channeldes",importance: Importance.max,priority: Priority.high,ticker: 'test ticker');
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,iOS: iOSChannelSpecifics );
    await flutterLocalNotificationsPlugin.show(0, 'Dat Hang Thanh Cong', 'Xin chuc mung ban da dat hang thanh cong , chung toi se kiem tra va giao hang cho ban som nhat',
        platformChannelSpecifics,payload: 'test payload');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettinggsAndroid = new AndroidInitializationSettings('icon_app');
    initializationSettinggsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettinggs =  new InitializationSettings(android: initializationSettinggsAndroid,iOS: initializationSettinggsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettinggs,onSelectNotification:onSelectNotification );

   
  }
  Future onSelectNotification(String payload) async{
    if (payload != null)
      {
        debugPrint('Notification payload: $payload');
      }
  }
  Future onDidReceiveLocalNotification( int id , String title , String body , String payload

      ) async{
    await showDialog(
      context: context,
      builder: (BuildContext context)=> CupertinoAlertDialog(
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
              colors: [Colors.pink,Colors.lightGreenAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end:  const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
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
                onPressed: ()=>addOrderDetails(),
                child: Text("PLace Order",style: TextStyle(fontSize: 30.0),),
              )
            ],
          ),
        ),
      ),
    );
  }
    getdatadashboard(){
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      String smonth =month.toString();
      String syear =year.toString();
      String b = smonth+ syear;
      FutureBuilder<DocumentSnapshot>(
        future: EcommerceApp.firestore
            .collection(EcommerceApp.collectiondashBoard)
            .document("122020")
            .get(),
        builder: (c,snap)
        {
          return snap.hasData
              ? DashBoardCard(model: DashBoardModel.fromJson(snap.data.data),)
              : Center(child: circularProgress(),);
        },
      );
    }
  addOrderDetails(){
    writeOrderDetailsForAdmin({
      EcommerceApp.addressID:widget.addressId,
      EcommerceApp.totalAmount:widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID:EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails:widget.paymentdetail,
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess:false,
    }).whenComplete(() => {
      emptyCartNow()
    });


  }
  emptyCartNow(){
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    Firestore.instance.collection("users")
    .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
    .updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value){
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();
    });
      shownotification();
    Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
    Navigator.pushReplacement(context, route);
  }
  


  Future writeDashBoard(Map<String, dynamic>data) async{
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    String smonth =month.toString();
    String syear =year.toString();
    String a = smonth+ syear;
    await EcommerceApp.firestore.collection(EcommerceApp.collectiondashBoard)
        .document(a)
        .updateData(data);
  }


  Future writeOrderDetailsForAdmin(Map<String, dynamic>data) async{
    await EcommerceApp.firestore.collection(EcommerceApp.collectionOrders)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+data['orderTime'])
        .setData(data);
    await  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+data['orderTime'])
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
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+data['orderTime'])
        .setData(data);
   }
  // Future writeitem() async{
  //   List<String> a = new List();
  //    a = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  //   int sl= a.length;
  //   for(int p=0;p>=sl;p++)
  //     {
  //
  //       FutureBuilder<DocumentSnapshot>(
  //         future: EcommerceApp.firestore
  //             .collection("items")
  //             .document(a[p])
  //             .get(),
  //         builder: (c,snap)
  //         {
  //           return snap.hasData
  //               ? {
  //             ItemModel.fromJson(snap.data.data)}
  //               : Center(child: circularProgress(),);
  //         },
  //       );
  //       ItemModel model ;
  //       int quanupdate = model.quantity-1;
  //       await EcommerceApp.firestore.collection("items")
  //           .document(a[p])
  //           .updateData({"quantity":quanupdate});}
  //     }


  // Future writeOrderDetailsForHistoryAdmin(Map<String, dynamic>data) async{
  //
  //   await EcommerceApp.firestore.collection(EcommerceApp.collectionHistoryAdmin)
  //       .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)+data['orderTime'])
  //       .setData(data);
  // }

}



