import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/bankcard.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddBankCard extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cccv = TextEditingController();
  final cidCard = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(formKey.currentState.validate())
            {
              final model = BankCardModel(
                name: cName.text.trim(),
                idCard: cidCard.text.trim(),
                ccv: cccv.text,
                sdt: cPhoneNumber.text,
              ).toJson();
              // add to firestoe
              EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.collectionBankCard)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value){
                final snack = SnackBar(content: Text("New Bank Card add successfully"),);
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c)=>StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
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
                  child: Text("Add New Bank Card",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20.0),),

                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "ID Card",
                      controller: cidCard,
                    ),
                    MyTextField(
                      hint: "CCV",
                      controller: cccv,
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
