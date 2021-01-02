import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/BankCard/addBankCard.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Orders/UserHistory.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Store/userprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
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
                Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
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
    Route route = MaterialPageRoute(builder: (c)=> StoreHome());
    Navigator.pushReplacement(context, route);

                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("My Order", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.card_travel,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> MyOrders());
                    Navigator.push(context, route);

                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("My Cart", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.shopping_cart,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> CartPage());
                    Navigator.push(context, route);

                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("Add Bank Card", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.credit_card,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AddBankCard());
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("Profile", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.person,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> UserProfile());
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("History", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.history,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> UserHistory());
                    Navigator.push(context, route);
                  },
                ),

                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("Add New Address", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.add_location,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AddAddress());
                    Navigator.push(context, route);

                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("Log out", style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.exit_to_app,color:Colors.white,),
                  onTap: (){
                    EcommerceApp.auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
                      Navigator.pushReplacement(context, route);

                    });

                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),

              ],
            ),
          ),
        ],

      ),
    );
  }
}
