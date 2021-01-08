import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/creatsale.dart';
import 'package:e_shop/BankCard/bcard.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/userchanger.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Models/usermodel.dart';
import 'package:e_shop/Orders/placeOrderPayment.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ManageUser extends StatefulWidget
{
  @override
  ManageUserState createState() => ManageUserState();
}


class ManageUserState extends State<ManageUser>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Manage user',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
              ),
            ),
            Consumer<AddressChanger>(builder: (context,address,c){
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .snapshots(),
                  builder: (context,snapshot){
                    return !snapshot.hasData
                        ? Center(child: circularProgress(),)
                        :snapshot.data.documents.length == 0
                        ? noAddressCard()
                        : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return UserCard(
                          currentIndex: address.count,
                          value: index,
                          model: UserModel.fromJson(snapshot.data.documents[index].data),
                        );
                      },
                    );
                  },
                ),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Creat sale"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.credit_card_sharp),
          onPressed: (){
            Route route =MaterialPageRoute(builder: (c)=>Creatsale());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),

    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Icon(Icons.add_location,color: Colors.white,),
            Text("Some thing wrong"),
         ],
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final UserModel model;
  final int currentIndex;
  final int value;

  UserCard({Key key,this.model,this.currentIndex,this.value}): super(key:  key);


  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<UserChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val){
                    Provider.of<UserChanger>(context,listen: false).displayResult(val);
                  },

                ),
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
                                KeyText(msg: "Name",),
                                Text(widget.model.name),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Level",),
                                Text(widget.model.lv),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Mail",),
                                Text(widget.model.mail),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Point",),
                                Text(widget.model.point),
                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
                 WideButton(
              message: "Chose",
              onPressed: ()
             {  List<String> list = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.adUser);
             String show = widget.model.name;
             String id = widget.model.id;
             list.add(id);
               EcommerceApp.sharedPreferences.setStringList(EcommerceApp.adUser, list);
               Fluttertoast.showToast(msg: "Chose  : "+show);

             }
            )
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
