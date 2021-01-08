import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/dashboardcard.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String dropdownValuey = '2020';
  String dropdownValuem = '12';
  String amount ;
  int month ;
  int year ;
  String smonth ;
  String ssmonth ='12';
  String date='122020';
  String syear='2020';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        leading: IconButton(
          icon: Icon(Icons.border_color,color: Colors.white,),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c)=>AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text("Log out",style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          )
        ],
      ),
      body:
      Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              icon: Icon(Icons.arrow_drop_down),
              value: dropdownValuem,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValuem = newValue;
                  ssmonth = newValue;
                  date=ssmonth+syear;



                });
              },
              isExpanded: true,
              items: <String>['01', '02', '03', '04',"05","06","07","08","09","10","11","12"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              icon: Icon(Icons.arrow_drop_down),
              value: dropdownValuey,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValuey = newValue;
                  syear = newValue;
                  date=ssmonth+syear;
                });
              },
              isExpanded: true,
              items: <String>['2020', '2021', '2022', '2023',"2024","2025","2026","2027","2028","2029","2030"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

          ),
          FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectiondashBoard)
                .document(date)
                .get(),
            builder: (c,snap)
            {
              return snap.data.data != null ? DashBoardCard(model: DashBoardModel.fromJson(snap.data.data)) : noBankCard();
            },
          )
        ],

      ),

      );

  }
  noBankCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Icon(Icons.hourglass_empty,color: Colors.white,),
            Text("No data for this month"),
          ],
        ),
      ),
    );
  }

}
class DashBoardCard extends StatefulWidget {
  final   DashBoardModel model;
  final int totalAmount;

  DashBoardCard({Key key,this.model,this.totalAmount}): super(key:  key);


  @override
  _DashBoardCardState createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return   InkWell(
      onTap: (){
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                KeyText(msg: "totalAmount",),
                                Text(widget.model.totalAmount.toString()),
                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );

  }
}
class KeyText extends StatelessWidget {
final String msg;

KeyText({Key key,this.msg}): super(key: key);
@override
Widget build(BuildContext context) {
  return Text(
    msg,
    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
  );
}
}

