import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Creatsale extends StatefulWidget {
  @override
  _CreatsaleState createState() => _CreatsaleState();
}

class _CreatsaleState extends State<Creatsale> {
  List list = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.adUser);
  TextEditingController _idsaleTextEdittingController = TextEditingController();
  TextEditingController _saleTextEdittingController = TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
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
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,)),
          title: Text("Update Product",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
          actions: [
            FlatButton(
              onPressed: (){saveItemInfo(list);
              Fluttertoast.showToast(msg: "Creat sale successful");
              Route route = MaterialPageRoute(builder: (c)=>UploadPage());
              Navigator.pushReplacement(context, route);
              },
              child: Text("Update",style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
            )
          ],
        ),
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 12.0)),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color:Colors.deepPurpleAccent),
                  controller: _idsaleTextEdittingController,
                  decoration: InputDecoration(
                    hintText: "idsale",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.pink,),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color:Colors.deepPurpleAccent),
                  controller: _saleTextEdittingController,
                  decoration: InputDecoration(
                    hintText: "sale %",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  saveItemInfo(List<String> iduser){
    String id=_idsaleTextEdittingController.text;
    String sale = _idsaleTextEdittingController.text;
    for(
    var idindex in iduser
    ){
      final itemRef = Firestore.instance.collection("users").document(idindex).collection(EcommerceApp.userSale);
      itemRef.document(id).setData({
        "id": id,
        "sale": sale,
      });
    }
    }


}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
