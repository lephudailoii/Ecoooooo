import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cnewPass = TextEditingController();
  final creNewPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            _changePassword(cnewPass.text.trim());
          },
          label: Text("Change Password"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Change Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),

                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "New Password",
                      controller: cnewPass,
                    ),
                    MyTextField(
                      hint: "Re New Password",
                      controller: creNewPass,
                    ),

                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword(String password) async{
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      Fluttertoast.showToast(msg: "Your password changed Succesfully ");
      Route route = MaterialPageRoute(builder: (c)=> StoreHome());
      Navigator.pushReplacement(context, route);
    }).catchError((err){
      var error = "Repeat password is invalid or Password too least";
      Fluttertoast.showToast(msg: error);
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });

  }
}
class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({Key key,this.hint,this.controller}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=>val.isEmpty? "Fiedl can not be empty":null,
      ),
    );
  }
}
