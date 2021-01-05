import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/bankcardchanger.dart';
import 'package:e_shop/Models/bankcard.dart';
import 'package:e_shop/Orders/placeOrderPayment.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addBankCard.dart';

class BankCard extends StatefulWidget
{final String addressId;
final double totalAmount;
  const BankCard ({Key key,this.totalAmount,this.addressId}): super(key: key);
  @override
  _BankCardState createState() => _BankCardState();
}


class _BankCardState extends State<BankCard>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Select Bank Card',
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0),),
              ),
            ),
            Consumer<AddressChanger>(builder: (context,address,c){
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.collectionBankCard).snapshots(),
                  builder: (context,snapshot){
                    return !snapshot.hasData
                        ? Center(child: circularProgress(),)
                        :snapshot.data.documents.length == 0
                        ? noBankCard()
                        : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return BankCardd(
                          currentIndex: address.count,
                          value: index,
                          bankCardId: snapshot.data.documents[index].documentID,
                          totalAmount: widget.totalAmount,
                          addid: widget.addressId,
                          model: BankCardModel.fromJson(snapshot.data.documents[index].data),
                        );
                      },
                    );
                  },
                ),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add New Bank Card"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.add),
          onPressed: (){
            Route route =MaterialPageRoute(builder: (c)=>AddBankCard());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),

    );
  }

  noBankCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Icon(Icons.add_location,color: Colors.white,),
            Text("No Bank Card has been saved"),
            Text("Pl add your Bank Card add "),
          ],
        ),
      ),
    );
  }
}

class BankCardd extends StatefulWidget {
  final BankCardModel model;
  final String bankCardId;
  final String idCard;
  final double totalAmount;
  final int ccv;
  final String addid;
  final int sdt;
  final String name;
  final int value;
  final int currentIndex;



  BankCardd({Key key,this.model,this.bankCardId,this.idCard,this.totalAmount,this.addid,this.ccv,this.sdt,this.name,this.value,this.currentIndex}): super(key:  key);


  @override
  _BankCarddState createState() => _BankCarddState();
}

class _BankCarddState extends State<BankCardd> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<BankCardChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val){
                    Provider.of<AddressChanger>(context,listen: false).displayResult(val);
                  },

                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                KeyText(msg: "Name",),
                                Text(widget.model.name),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "sdt",),
                                Text(widget.model.sdt.toString()),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "ccv",),
                                Text(widget.model.ccv.toString()),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "idCard",),
                                Text(widget.model.idCard.toString()),
                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<BankCardChanger>(context).count
                ? WideButton(
              message: "Proceed",
              onPressed: ()
              {
                Route route = MaterialPageRoute(builder: (c)=>PaymentPage(
                  addressId : widget.addid,
                  totalAmount: widget.totalAmount,
                  paymentdetail: " Bank Card",
                ));
                Navigator.push(context, route);
              },
            )
                :Container()
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key,this.msg}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
    );
  }
}
