import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Widgets/myDrawerDefault.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPageDefault extends StatefulWidget {
  @override
  _CartPageDefaultState createState() => _CartPageDefaultState();
}

class _CartPageDefaultState extends State<CartPageDefault> {
  double totalAmount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount =0;
    Provider.of<TotalAmount>(context,listen: false).display(0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length==1)
          {
            Fluttertoast.showToast(msg: "your cart is empty");
          }
          else
          {
            Fluttertoast.showToast(msg: "Plese Sign In");
          }
        },
        label: Text("Sign In"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawerDefault(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount,CartItemCounter>(builder: (context,amountProvider,cartProvider,c)
            {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child:
                       Text("Total Price : ${amountProvider.totalAmount.toString()}",
                    style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp.firestore.collection("items").where("id",whereIn: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)).snapshots(),
              builder: (context,snapshot){
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(child: circularProgress(),),
                )
                    :snapshot.data.documents.length==0
                    ? beginBuildingCart()
                    :SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context,index){
                      ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
                      String iditem = snapshot.data.documents[index].documentID;

                      if (index ==0)
                      {
                        totalAmount = 0;
                        totalAmount = model.price + totalAmount;
                      }
                      else
                      {
                        totalAmount = model.price + totalAmount;
                      }
                      if(snapshot.data.documents.length-1 ==index){
                        WidgetsBinding.instance.addPostFrameCallback((t) {
                          Provider.of<TotalAmount>(context,listen: false).display(totalAmount);
                        });
                      }
                      return sourceInfo(model, context,iditem,removeCartFunction: ()=> removeItemFromUserCart(model.shortInfo));
                    },
                    childCount:  snapshot.hasData ? snapshot.data.documents.length : 0,
                  ),
                );
              }
          )
        ],
      ),
    );
  }
  beginBuildingCart(){
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon,color: Colors.white,),
              Text("Cart is empty"),
              Text("Start adding item to cart"),
            ],
          ),
        ),
      ),
    );
  }
  removeItemFromUserCart(String shortInfoAsId){
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);
    // EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
    //     .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
    //     .updateData({
    //   EcommerceApp.userCartList: tempCartList,
    // }).then((v){
    //
    // });
    Fluttertoast.showToast(msg: "Item Remove Success");
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context,listen: false).displayResult();
    totalAmount =0;
  }
}
