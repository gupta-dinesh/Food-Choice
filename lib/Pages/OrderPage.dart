import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Service/auth.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Service/shared_prefrence.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int total=0,amount2=0;
  String?id,wallet,cartItemId;

  getTheSharedPref()async{
    id = await AuthMethods().getCurrentUserDocumentId();
    print("Id: $id");
    wallet = await DatabaseMethod().getWalletMoney(id!);
    print("orderpage : $wallet");
    setState(() {

    });
  }
  cartTotalPrice()async{
    total=await DatabaseMethod().cartTotalPrice(id!);
    print("Total : $total");
    setState(() {

    });
  }
  /*void startTimer(){
    Timer(Duration(seconds: 1),(){
      amount2=total;
      print("Amount2:$amount2");
      setState(() {});
    });
  }*/

  onTheLoad()async{
    await getTheSharedPref();
    cartTotalPrice();
    foodStream = await DatabaseMethod().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    //startTimer();
    super.initState();
  }

  Stream ? foodStream;

  // Fatching Items which are added to cart --->
  Widget foodcart(){
    return StreamBuilder(
        stream: foodStream,
        builder:(context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index){
            DocumentSnapshot ds =snapshot.data.docs[index];
            //total=total+int.parse(ds["Total"]);
            cartItemId=ds["ItemId"];
            return Container(
              margin: EdgeInsets.only(right: 10,left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(4)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          ds["Quantity"],style: AppWidget.semiBoldTextFields(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(ds["Image"],height: 90,width: 90,fit: BoxFit.cover,),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ds["Name"],style: AppWidget.semiBoldTextFields(),maxLines: 2,),
                      Text("\u{20B9} "+ds["Total"],style: AppWidget.semiBoldTextFields(),),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:(context){
                          return AlertDialog(
                            content: const Text("Are Sure to remove?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // delete item from cart ---->
                              TextButton(
                                onPressed: () async {
                                  await DatabaseMethod().DeleteFromCart(id!, cartItemId!);
                                  cartTotalPrice();//Call to update the amounnt
                                  Navigator.of(context).pop();
                                  //startTimer();
                                },
                                child: const Text("Yes",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );

          }):Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Material(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidget.HeadLineTextFields(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            // Added Food in cart
            Container(
              height: MediaQuery.of(context).size.height/2,
                child: foodcart()
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price",style: AppWidget.boldTextFields(),),
                  Text("\u{20B9} "+total.toString(),style: AppWidget.semiBoldTextFields(),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                if(total>0){
                  if(int.parse(wallet!) >= total){
                    int amount = int.parse(wallet!)-total;
                    print("money :$wallet");
                    await DatabaseMethod().UpdateUserWallet(id!, amount.toString());
                    //await SharedPrefrenceHelper().saveUserWallet(amount.toString());
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
                                Text("Order placed successsfully and money is deducted from your wallet.",
                                  style:TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),);
                  }
                  else if(int.parse(wallet!)<total){
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                                Text("No enough amount in your wallet !",
                                  style:TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),);
                  }
                }

              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.lightBlueAccent,
                ),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
