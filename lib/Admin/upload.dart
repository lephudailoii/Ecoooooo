import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Uploaditem extends StatefulWidget {
  final ItemModel itemModel;
  final String iditem;
  Uploaditem({this.itemModel,this.iditem});
  @override
  _UploaditemState createState() => _UploaditemState();
}



class _UploaditemState extends State<Uploaditem> {
  TextEditingController _descriptionTextEdittingController = TextEditingController();
  TextEditingController _priceTextEdittingController = TextEditingController();
  TextEditingController _titleTextEdittingController = TextEditingController();
  TextEditingController _shortInfoTextEdittingController = TextEditingController();
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
              onPressed: (){saveItemInfo(widget.iditem);
                       Fluttertoast.showToast(msg: "Update Successful");
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
                  controller: _shortInfoTextEdittingController,
                  decoration: InputDecoration(
                    hintText: widget.itemModel.shortInfo,
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
                  controller: _titleTextEdittingController,
                  decoration: InputDecoration(
                    hintText: widget.itemModel.title,
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
                  controller: _descriptionTextEdittingController,
                  decoration: InputDecoration(
                    hintText: widget.itemModel.longDescription,
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
                  keyboardType: TextInputType.number,
                  style: TextStyle(color:Colors.deepPurpleAccent),
                  controller: _priceTextEdittingController,
                  decoration: InputDecoration(
                    hintText: widget.itemModel.price.toString(),
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.pink,),
          ],
        ),
      ),
    );
  }
  saveItemInfo(String iditem){
    String a=_shortInfoTextEdittingController.text;

    final itemRef = Firestore.instance.collection("items");
    itemRef.document(iditem).updateData({
      "shortInfo": a,
      "longDescription": _descriptionTextEdittingController.text,
      // "price": int.parse(_priceTextEdittingController.text),
      "status": "available",
      "title": _titleTextEdittingController.text.trim(),});}

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
