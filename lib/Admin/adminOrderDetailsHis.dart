import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AdminOrderDetailsHis extends StatelessWidget {
  final String orderID;
  final String addressID;
  final String orderBy;
  AdminOrderDetailsHis({Key key,this.orderID,this.addressID,this.orderBy}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionHistoryAdmin)
                .document(getOrderId)
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
                    AdminStatusBanner(status: dataMap[EcommerceApp.isSuccess],
                      step: dataMap[EcommerceApp.step],),
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
                      child: Text("Order ID: " + getOrderId),
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
                          .where("id",whereIn: dataMap[EcommerceApp.productID])
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
                          .document(orderBy)
                          .collection(EcommerceApp.subCollectionAddress)
                          .document(addressID)
                          .get(),
                      builder: (c,snap)
                      {
                        return snap.hasData
                            ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data),)
                            : Center(child: circularProgress(),);
                      },
                    )
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

class AdminStatusBanner extends StatelessWidget {

  final String step;
  final bool status;
  AdminStatusBanner({Key key,this.status,this.step}): super(key: key);

  @override
  Widget build(BuildContext context) {
    String state;
    IconData iconData;
    if(step =="1")
    {
      state ="Order is being processing";

    }
    else if(step =="2")
    {state ="Order have been deleted";}
    else
    {state ="Order have been completed";}
    status ? iconData = Icons.done : iconData = Icons.cancel;

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
          Text("Order Shipped : "+state ,style: TextStyle(color: Colors.white),
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



class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;
  AdminShippingDetails({Key key,this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }

}





