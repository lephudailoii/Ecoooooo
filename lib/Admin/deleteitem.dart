import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/deletecomment.dart';
import 'package:e_shop/Admin/upload.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_shop/Store/horizonlv.dart';


double width;
class Deleteitem extends StatefulWidget {
  @override
  _DeleteitemState createState() => _DeleteitemState();
}

class _DeleteitemState extends State<Deleteitem> {
  String iditem ;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            "E-FASHION-SHOP",style: TextStyle(fontSize: 55.0,color: Colors.white,fontFamily: "Signatra"),

          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.delete,color: Colors.pink,),
                  onPressed: ()
                  {
                    // Route route = MaterialPageRoute(builder: (c)=> CartPage());
                    // Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,
                        size: 20.0,
                        color: Colors.green,),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context,counter,_){
                            return Text(
                              (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                              style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        body:
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate(),),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
                builder: (context,dataSnapshot)
                {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                      : SliverStaggeredGrid.countBuilder(crossAxisCount: 1, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      iditem = dataSnapshot.data.documents[index].documentID;
                      return sourceInfo(model, context,iditem);
                    }, itemCount: dataSnapshot.data.documents.length,);
                }
            )

          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context, String iditem,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c)=>Uploaditem(itemModel:model,iditem: iditem,));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 250.0,
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
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child:
                           IconButton(
                        icon: Icon(Icons.delete,color: Colors.pinkAccent,),
                        onPressed: (){
                          deleteitem(context,iditem);
                        },
                      )

                      ),
                  Align(
                      alignment: Alignment.centerRight,
                      child:
                      IconButton(
                        icon: Icon(Icons.comment,color: Colors.pinkAccent,),
                        onPressed: (){
                          Route route = MaterialPageRoute(builder: (c)=>CommentAdmin(iditem: iditem));
                          Navigator.push(context, route);                        },
                      )

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



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width*.34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(offset: Offset(0,5),blurRadius: 10.0,color: Colors.grey[200]),
        ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width*.34,
        fit: BoxFit.fill ,
      ),
    ),
  );
}



// void checkItemInCart(String shortInfoAsID, BuildContext context)
// {
//   EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsID)
//       ? Fluttertoast.showToast(msg: "Item is aldeady in Cart")
//       : addItemToCart(shortInfoAsID,context);
// }
//
// addItemToCart(String shortInfoAsID,BuildContext context){
//   List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
//   tempCartList.add(shortInfoAsID);
//   EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
//       .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .updateData({
//     EcommerceApp.userCartList: tempCartList,
//   }).then((v){
//     Fluttertoast.showToast(msg: "Item Add Success");
//     EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
//     Provider.of<CartItemCounter>(context,listen: false).displayResult();
//   });
//
// }
deleteitem(BuildContext context,String shortinfoasad)
{
  EcommerceApp.firestore
      .collection("items")
      .document(shortinfoasad)
      .delete();}

Widget image_carousel = new Container(
  height: 200.0,
  child: new CarouselSlider(
    options: CarouselOptions(height: 400.0),
    items: [1,2,3,4].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Image.asset('images/cash.png'),
          );
        },
      );
    }).toList(),
  ),
);
