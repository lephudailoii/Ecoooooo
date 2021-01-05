import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
              Route route = MaterialPageRoute(builder: (c)=>Address(totalAmount:totalAmount));
              Navigator.push(context, route);
            }
        },
        label: Text("Check Out"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount,CartItemCounter>(builder: (context,amountProvider,cartProvider,c)
            {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count==0
                    ? Container()
                        : Text("Total Price : ${amountProvider.totalAmount.toString()}",
                    style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w500),
                    ),
                  ),
                );
            }
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.userCartList).where("id",whereIn: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)).snapshots(),
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
                          totalAmount = model.price*model.quantity + totalAmount;
                        }
                      else
                        {
                        totalAmount = model.price*model.quantity + totalAmount;
                      }
                      if(snapshot.data.documents.length-1 ==index){
                        WidgetsBinding.instance.addPostFrameCallback((t) {
                          Provider.of<TotalAmount>(context,listen: false).display(totalAmount);
                        });
                      }
                      return sourceInfoCart(model,context,iditem,removeCartFunction: ()=> removeItemFromUserCart(model.id));
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
  removeItemFromUserCart(String iditem){
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList)
        .document(iditem)
        .delete();
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(iditem);
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Remove Success");
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context,listen: false).displayResult();
      totalAmount =0;
    });
  }
}
  updatequan(String iditem,int quan)
  {
    final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.userCartList);
    itemRef.document(iditem).updateData({
      "quantity": quan,});
  }

Widget sourceInfoCart(ItemModel model, BuildContext context,String iditem,
    {Color background, removeCartFunction}) {
  final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.userCartList);
  int quantity =   model.quantity;
  return InkWell(
    onTap: (){

    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink
                        ),
                        alignment: Alignment.topLeft,
                        width: 40.0,
                        height: 40.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("50%",style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),),
                              Text("OFF",style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("Price",style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text((model.price + model.price).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("New Price",style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text((model.price).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.grey),),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("Quantity: ",style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text((quantity).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.grey),),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete,color: Colors.pinkAccent,),
                            onPressed: (){removeCartFunction();

                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(Icons.plus_one,color: Colors.pinkAccent,),
                            onPressed: (){
                              quantity = quantity+1;
                              updatequan(iditem, quantity);
                              String z= quantity.toString();
                              Fluttertoast.showToast(msg: z);
                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:IconButton(
                            icon: Icon(Icons.exposure_minus_1,color: Colors.pinkAccent,),
                            onPressed: (){
                              if(quantity>1)
                              {   quantity = quantity-1;
                              updatequan(iditem, quantity);
                              String q= quantity.toString();
                              Fluttertoast.showToast(msg: q);
                              }
                            },
                          )
                      ),
                    ],
                  ),
                  Divider(height: 5.0,color: Colors.pinkAccent,)
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

}
