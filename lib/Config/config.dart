import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp
{
   static const String appName = 'e-Shop';

   static SharedPreferences sharedPreferences;
   static FirebaseUser user;
   static FirebaseAuth auth;
   static Firestore firestore ;

   static String collectionUser = "users";
   static String collectionOrders = "orders";
   static String collectionBankCard ="bankCard";
   static String collectionHistoryUser = "historyUser";
   static String collectionHistoryAdmin = "historyAdmin";
   static String collectionComment = "comment";
   static String userCartList = 'userCart';
   static String userCartListQuantity='userCartQuantity' ;
   static String collectiondashBoard ='dashBoard';
   static String subCollectionAddress = 'userAddress';

   static final String userName = 'name';
   static final String userEmail = 'email';
   static final String userPhotoUrl = 'photoUrl';
   static final String userUID = 'uid';
   static final String userAvatarUrl = 'url';

   static final String addressID = 'addressID';
   static final String totalAmount = 'totalAmount';
   static final String productID = 'productIDs';
   static final String paymentDetails ='paymentDetails';
   static final String orderTime ='orderTime';
   static final String step = 'step';
   static final String isSuccess ='isSuccess';

   static Future<bool> setSharePrefercence(String key, String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString(key, value);
   }

   static Future<String> getSharePrefercence(String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
   }
}