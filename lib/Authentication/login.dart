import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  bool _isLogIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png",
              height: 240.0,
              width: 240.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login to your account",
              style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: (){
              loginUser();
              },
              color: Colors.pink,
              child: Text("Sign up",style: TextStyle(color: Colors.white),),
            ),
            RaisedButton(
              onPressed: (){
                loginGG();
              },
              color: Colors.pink,
              child: Text("Sign up with Google",style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth*0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage())),
              icon: (Icon(Icons.nature_people,color: Colors.pink,)),
              label: Text("i'm Admin",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),

            ),
          ],
        ),
      ),
    );

  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async
  {
    showDialog(
     context: context,
     builder: (c){
       return LoadingAlertDialog(message: "Authencating ,wait",);
     }
    );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: error.message.toString(),);
        }
      );
    });
    if(firebaseUser != null)
      {
        readData(firebaseUser).then((s){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
  }
  void loginGG() async{
      await _googleSignIn.signIn();
      FirebaseUser firebaseUser;
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _googleSignIn.currentUser.displayName);
      Route route = MaterialPageRoute(builder: (c)=> StoreHome());
      Navigator.pushReplacement(context, route);
      setState(() {
        _isLogIn = true;
      });
  }
  Future readData(FirebaseUser fUser)async{
    await Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)
    async{
      await EcommerceApp.setSharePrefercence("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.Point,dataSnapshot[EcommerceApp.Point]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userLevel, dataSnapshot.data[EcommerceApp.userLevel]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userSale,"0");
      await EcommerceApp.setSharePrefercence(EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList );

    });

  }
}


