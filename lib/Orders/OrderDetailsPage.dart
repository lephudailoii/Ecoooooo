import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId="";
class OrderDetails extends StatelessWidget {
  final String orderID;
  OrderDetails({Key key,this.orderID}): super(key:  key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
            .get(),
            builder: (c,snapshot)
            {
              Map dataMap;
              if(snapshot.hasData)
                {
                  dataMap = snapshot.data.data;
                }
              return snapshot.hasData
                  ? Container(
                child: Column(
                  children: [
                    StatusBanner(status: dataMap[EcommerceApp.isSuccess],
                    step: dataMap[EcommerceApp.step],
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "VND" + dataMap[EcommerceApp.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0),
                    child: Text("Order ID: " + orderID),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Oredered at: " + DateFormat("dd MMM,yyyy -hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch((int.parse(dataMap["orderTime"]))),
                        ),
                      ),
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore
                      .collection("items")
                      .where("shortInfo",whereIn: dataMap[EcommerceApp.productID])
                      .getDocuments(),
                      builder: (c,dataSnapshot)
                      {
                        return dataSnapshot.hasData
                            ? OrderCard(
                          itemCount: dataSnapshot.data.documents.length,
                          data: dataSnapshot.data.documents,
                        )
                            :Center(child: circularProgress(),);
                      },
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<DocumentSnapshot>(
                      future: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                          .collection(EcommerceApp.subCollectionAddress)
                          .document(dataMap[EcommerceApp.addressID])
                          .get(),
                      builder: (c,snap)
                      {
                        return snap.hasData
                            ? ShippingDetails(model: AddressModel.fromJson(snap.data.data),status:dataMap[EcommerceApp.isSuccess])
                            : Center(child: circularProgress(),);
                      },
<<<<<<< Updated upstream
                    )
=======
                    ),
>>>>>>> Stashed changes
                  ],
                ),
              )
                  :Center(child: circularProgress(),);
            },
          ),
        ),
    ),
    );
  }
}



class StatusBanner extends StatelessWidget {
  final bool status;
  final String step;
  StatusBanner({Key key,this.status,this.step}): super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Incominggg to Customers" : msg = "Waitting for admin check";

    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink,Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end:  const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          )
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text("Order Placed : " + msg ,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}





class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  final bool status;

  ShippingDetails({Key key,this.model,this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0 ),
          child: Text(
            "shipment details: ",
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),

          ),
        ),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 90.0,vertical: 5.0),
    width: screenWidth,
    child: Table(
    children: [
    TableRow(
    children: [
    KeyText(msg: "Name",),
    Text(model.name),
    ]
    ),
    TableRow(
    children: [
    KeyText( msg: "Phone Number",),
    Text(model.phoneNumber),
    ]
    ),
    TableRow(
    children: [
    KeyText(msg: "Flat Number",),
    Text(model.flatNumber),
    ]
    ),
    TableRow(
    children: [
    KeyText(msg: "City",),
    Text(model.city),
    ]
    ),
    TableRow(
    children: [
    KeyText(msg: "State",),
    Text(model.state),
    ]
    ),
    TableRow(
    children: [
    KeyText(msg: "Pin Code",),
    Text(model.pincode),
    ]
    ),
    ],
    ),
    ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                 if(status==true){
                  confirmedUserOrderReceived(context,getOrderId);
               }
                 else {
                   Fluttertoast.showToast(msg: "Pls waiting for admin check");
                 }
              },
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Confimed || Item Received",
                    style: TextStyle(color: Colors.white,fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: (){
                if(status==true){
                  Fluttertoast.showToast(msg: "Cannot delete because order has been deli for you");

               }
                else {
                  delete(context, getOrderId,EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) );
               }
              },
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
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white,fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        )

      ],
    );
  }
  confirmedUserOrderReceived(BuildContext context,String mOrderId)
  {
<<<<<<< Updated upstream
=======
    final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionHistoryUser);
    itemRef.document(mOrderId).updateData({
      EcommerceApp.step:"3"
    }
    );
    final itemRefad = Firestore.instance.collection(EcommerceApp.collectionHistoryAdmin);
    itemRefad.document(mOrderId).updateData({
      EcommerceApp.step:"3"
    }
    );
>>>>>>> Stashed changes
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();

    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order has been Received");
    }
  delete(BuildContext context,String mOrderId,String orderBy)
  {
    final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.collectionHistoryUser);
    itemRef.document(mOrderId).updateData({
        EcommerceApp.step:"2"
    }
    );
    final itemRefad = Firestore.instance.collection(EcommerceApp.collectionHistoryAdmin);
    itemRefad.document(mOrderId).updateData({
      EcommerceApp.step:"2"
    }
    );
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(orderBy)
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(orderBy)
        .collection(EcommerceApp.collectionHistoryUser)
        .document(mOrderId)
        .delete();
<<<<<<< Updated upstream


=======
>>>>>>> Stashed changes
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order has been Delete");
  }

}




