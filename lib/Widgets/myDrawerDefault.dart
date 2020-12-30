import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Orders/UserHistory.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Store/storehomedefault.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawerDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end:  const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: CircleAvatar(
                  ),
                ),

                SizedBox( height:10.0,),
                Text("Empty",
                  style: TextStyle(color: Colors.white,fontSize: 35.0,fontFamily: "Signatra"),),
              ],
            ),
          ),
          SizedBox(height: 12.0,),
          Container(
            padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end:  const FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home,color:Colors.white,),
                  title: Text("Home", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> StoreHomeDefault());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind,color:Colors.white,),
                  title: Text("Sign Up/In", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
                    Navigator.push(context, route);
                  },
                ),
              ],
            ),
          ),
        ],

      ),
    );
  }
}
