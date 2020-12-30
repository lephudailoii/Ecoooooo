import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/AdHistory.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Admin/dashboard.dart';
import 'package:e_shop/Admin/deleteitem.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEdittingController = TextEditingController();
  TextEditingController _priceTextEdittingController = TextEditingController();
  TextEditingController _titleTextEdittingController = TextEditingController();
  TextEditingController _shortInfoTextEdittingController = TextEditingController();
  TextEditingController _quantityTextEdittingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading =false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }
  displayAdminHomeScreen(){
      return Scaffold(
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
      leading: IconButton(
        icon: Icon(Icons.border_color,color: Colors.white,),
        onPressed: (){
          Route route = MaterialPageRoute(builder: (c)=>AdminShiftOrders());
          Navigator.pushReplacement(context, route);
        },
      ),
            actions: [
              FlatButton(
                child: Text("Log out",style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
                  Navigator.pushReplacement(context, route);
                },
              )
            ],
      ),
        body: getAdminHomeScreenBody(),
      );
  }
  getAdminHomeScreenBody()
  {

        return  Container(
  decoration: new BoxDecoration(
  gradient: new LinearGradient(
  colors: [Colors.pink,Colors.lightGreenAccent],
  begin: const FractionalOffset(0.0, 0.0),
  end:  const FractionalOffset(1.0, 0.0),
  stops: [0.0,1.0],
  tileMode: TileMode.clamp,
  )
  ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded,color: Colors.white,size: 50.0,),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                    child: Text("Add New Items",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                    color: Colors.green,
                    onPressed: ()=>takeImage(context),
                  ),
                ),
                Icon(Icons.history,color: Colors.white,size: 50.0,),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                    child: Text("History",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                    color: Colors.green,
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c)=> AdHistory() );
                      Navigator.push(context, route);
                    },
                  ),
                ),
                Icon(Icons.dashboard,color: Colors.white,size: 50.0,),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                    child: Text("DashBoard",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                    color: Colors.green,
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c)=> DashBoard() );
                      Navigator.push(context, route);
                    },
                  ),
                ),
                Icon(Icons.system_update_tv_outlined,color: Colors.white,size: 50.0,),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                    child: Text("Upload",style: TextStyle(fontSize: 20.0,color: Colors.white),),
                    color: Colors.green,
                    onPressed: (){
                      Route route = MaterialPageRoute(builder: (c)=> Deleteitem() );
                      Navigator.push(context, route);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (con)
        {return SimpleDialog(
          title: Text("Item Image",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              child: Text("Capture with Camera",style: TextStyle(color: Colors.green),),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Pick photo from gallery",style: TextStyle(color: Colors.green),),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel",style: TextStyle(color: Colors.green),),
              onPressed:(){ Navigator.pop(context);}
            ),

          ],
        );
        }
    );
  }
  capturePhotoWithCamera()async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0,maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }
  pickPhotoFromGallery()async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }
  displayAdminUploadFormScreen(){
return Scaffold(
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
    leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: clearFormInfo,),
    title: Text("New Product",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
    actions: [
      FlatButton(
        onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo(),
        child: Text("ADD",style: TextStyle(color: Colors.pink,fontSize: 16.0,fontWeight: FontWeight.bold),),
      )
    ],
  ),
  body: ListView(
    children: [
      uploading ? linearProgress() : Text(""),
      Container(
        height: 230.0,
        width: MediaQuery.of(context).size.width*0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)),
            ),
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 12.0)),
      ListTile(
        leading: Icon(Icons.perm_device_information,color: Colors.pink,),
        title: Container(
          width: 250.0,
          child: TextField(
            style: TextStyle(color:Colors.deepPurpleAccent),
            controller: _shortInfoTextEdittingController,
            decoration: InputDecoration(
              hintText: "Short Info",
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
              hintText: "Title",
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
              hintText: "Description",
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
            controller: _quantityTextEdittingController,
            decoration: InputDecoration(
              hintText: "Quantity",
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
              hintText: "Price",
              hintStyle: TextStyle(color: Colors.deepPurpleAccent),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      Divider(color: Colors.pink,),
    ],
  ),
);
  }
  clearFormInfo(){
   setState(() {
     file = null;
     _descriptionTextEdittingController.clear();
     _priceTextEdittingController.clear();
     _shortInfoTextEdittingController.clear();
     _titleTextEdittingController.clear();
     _quantityTextEdittingController.clear();
   });
  }
  uploadImageAndSaveItemInfo() async{
    setState(() {
      uploading =true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl){
    final itemRef = Firestore.instance.collection("items");
    itemRef.document(productId).setData({
      "id":productId,
     "shortInfo": _shortInfoTextEdittingController.text.trim(),
      "longDescription": _descriptionTextEdittingController.text.trim(),
      "price": int.parse(_priceTextEdittingController.text),
      "quantity": int.parse(_quantityTextEdittingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEdittingController.text.trim(),

    }
    );
    setState(() {
      file =null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEdittingController.clear();
      _titleTextEdittingController.clear();
      _shortInfoTextEdittingController.clear();
      _priceTextEdittingController.clear();
      _quantityTextEdittingController.clear();
    });
  }
}
