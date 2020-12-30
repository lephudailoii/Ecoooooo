import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/changepassword.dart';
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

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
         // Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=>ChangePassword());
          Navigator.pushReplacement(context, route);
        },
        label: Text("Back"),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.arrow_back_sharp),
      ),
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
                icon: Icon(Icons.shopping_cart,color: Colors.pink,),
                onPressed: ()
                {
                  Route route = MaterialPageRoute(builder: (c)=> CartPage());
                  Navigator.push(context, route);
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
      drawer: MyDrawer(),
      body: profileView(),
    );
  }
  Widget profileView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(height: 50, width: 50 ,child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.black54,), decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10))),),
              Text('Profiles details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Container(height: 24,width: 24)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                child: ClipOval(child: Image.asset('images/login.png', height: 150, width: 150, fit: BoxFit.cover,),),
              ),
              Positioned(bottom: 1, right: 1 ,child: Container(
                height: 40, width: 40,
                child: Icon(Icons.add_a_photo, color: Colors.white,),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ))
            ],
          ),
        ),
        Expanded(child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)]
              )
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName), style: TextStyle(color: Colors.white70),),
                    ),
                  ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail), style: TextStyle(color: Colors.white70),),
                    ),
                  ), decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),border: Border.all(width: 1.0, color: Colors.white70)),
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}

