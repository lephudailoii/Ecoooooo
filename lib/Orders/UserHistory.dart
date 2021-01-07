import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/orderHisCard.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class UserHistory extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<UserHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace : Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end:  const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          centerTitle: true,
          title: Text("My History Order",style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),
              onPressed: (){
                SystemNavigator.pop();
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionHistoryUser).snapshots(),
          builder: (c,snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (c,index){
                return FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection("items")
                      .where("id",whereIn: snapshot.data.documents[index].data[EcommerceApp.productID])
                      .getDocuments(),
                  builder: (c,snap){
                    return snap.hasData
                        ? OrderCardUserHis(
                      itemCount: snap.data.documents.length,
                      data: snap.data.documents,
                      orderID: snapshot.data.documents[index].documentID,
                    )
                        :Center(child: circularProgress(),);
                  },
                );
              },
            )
                :Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
