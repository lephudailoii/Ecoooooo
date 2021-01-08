import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'comment.dart';


class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  final String iditem;
  ProductPage({this.itemModel,this.iditem});
  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemModel.title,style: boldTextStyle,),
                          SizedBox(height: 10.0,),
                          Text(widget.itemModel.shortInfo),
                          SizedBox(height: 10.0,),
                          Text(widget.itemModel.title,style: boldTextStyle,),
                          SizedBox(height: 10.0,),
                          Text(widget.itemModel.longDescription),
                          SizedBox(height: 10.0,),
                          Text("" + widget.itemModel.price.toString(),style: boldTextStyle,),
                          SizedBox(height: 10.0,)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: ()=> checkItemInCart(widget.itemModel.id,widget.itemModel, context),
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
                          width: MediaQuery.of(context).size.width -40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: (){
                          Route route = MaterialPageRoute(builder: (c)=>Comment(iditem: widget.iditem));
                          Navigator.push(context, route);
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
                          width: MediaQuery.of(context).size.width -40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Review and comment",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
Future writeitem() async{
  List<String> a = new List();
  a = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  int sl= a.length;
  for(int p=0;p>=sl;p++)
  {

    FutureBuilder<DocumentSnapshot>(
      future: EcommerceApp.firestore
          .collection("items")
          .document(a[p])
          .get(),
      builder: (c,snap)
      {
        return snap.hasData
            ? {
          ItemModel.fromJson(snap.data.data)}
            : Center(child: circularProgress(),);
      },
    );
    ItemModel model ;
    int quanupdate = model.quantity-1;
    await EcommerceApp.firestore.collection("items")
        .document(a[p])
        .updateData({"quantity":quanupdate});}
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
