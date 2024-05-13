import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/Pages/Onboarding_Content.dart';
import 'package:food_delivery/Service/auth.dart';
import 'package:food_delivery/Service/database.dart';
//import 'package:food_delivery/Service/shared_prefrence.dart';
import 'package:food_delivery/Widgets/secret.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  String? walletMoney , Id;
  int? add;
  TextEditingController randomAmountController = TextEditingController();

  getSharedPref()async{
    //walletMoney = await SharedPrefrenceHelper().getUserWallet();
    Id = await AuthMethods().getCurrentUserDocumentId();
    walletMoney = await DatabaseMethod().getWalletMoney(Id!);
    print("wwallet money : $walletMoney");
    setState(() {

    });
  }

  onTheLoad() async{
    await getSharedPref();
    setState(() {

    });
  }

  // we want to call OnTheLoad() before loading the wallet page
  @override
  void initState(){
    onTheLoad();//
    super.initState();
  }

  //  Function to add Random Amount in wallet -----

  Future RandomAmount() => showDialog(context: context, builder: (context)=>AlertDialog(
    content: SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                    child: Icon(Icons.cancel),
                ),
                SizedBox(width: 60,),
                Center(
                  child: Text("Add money",style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Amount",style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: randomAmountController,
                decoration:InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Amount",
                ),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap:() {
                Navigator.pop(context);
                makePayement(randomAmountController.text);
              },
              child: Center(
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text("Pay",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ));

  // payment----

  Map<String,dynamic> ? paymentIntent;
  Future<void> makePayement(String amount) async{
    try{
      paymentIntent = await createPaymentIntent(amount,"INR");
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!["client_secret"],
              style: ThemeMode.dark,
              merchantDisplayName: "Adnan")).
      then((value) {});
      displayPaymentSheet(amount);
    }catch (e,s){
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        add = int.parse(walletMoney!)+int.parse(amount);
        //await SharedPrefrenceHelper().saveUserWallet(add.toString());
        await DatabaseMethod().UpdateUserWallet(Id!, add.toString());
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text("Payment Successfull"),
                    ],
                  )
                ],
              ),
            ),);

        // after showing payment successfull -> update wallet amount instantly
        await getSharedPref();

        paymentIntent =null;
      }).onError((error, stackTrace) {
        print("Error is:---->$error $stackTrace");
      });
    }on StripeException catch(e){
      print('Error is:---->$e');
      showDialog(
          context: context,
          builder:(_) => const AlertDialog(
            content: Text("Cancelled"),
          ),
      );
    }catch(e){
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async{
    try{
      Map<String,dynamic> body ={
        "amount":calculateAmount(amount),
        "currency":currency,
        "payment_method_types[]":"card"
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers:{
          'Authorization':'Bearer $secretKey',
          'content-Type':'application/x-www-form-urlencoded'
        },
        body :body,
      );
      print("Payment Intent Body->>> ${response.body.toString()}");
      return jsonDecode(response.body);
    }catch (err){
      print('error charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount){
    final calaculatedAmount = (int.parse(amount)*100);
    return calaculatedAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: walletMoney == null
        ? Center(
        child: CircularProgressIndicator(color: Colors.lightBlueAccent,),
        )
      : Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Container(
              child: Text(
                "Wallet",
                style: AppWidget.HeadLineTextFields(),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFE5F1F8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color:Color(0xFFE9E2E2)),
              ),
              child: Row(
                children: [
                  Image.asset("assets/images/wallet.png",height: 60,width: 60,fit: BoxFit.cover,),
                  SizedBox(width: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Wallet",style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height:5,),
                      Text('\u{20B9}'+walletMoney!,
                        style:AppWidget.semiBoldTextFields() ,
                      ),
                    ]
                  ),
                ]
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 20),
                child: Text("Add Money",style: AppWidget.semiBoldTextFields(),)
            ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 GestureDetector(
                   onTap: () {
                     makePayement("100");
                   },
                   child: Material(
                     elevation: 5,
                     borderRadius: BorderRadius.circular(12),
                     child: Container(
                       padding:EdgeInsets.all(5),
                       decoration: BoxDecoration(
                         border: Border.all(color:Color(0xFFE9E2E2)),
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Text(
                         "\u{20B9} 100",
                         style: AppWidget.semiBoldTextFields(),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     makePayement("500");
                   },
                   child: Material(
                     elevation: 5,
                       borderRadius: BorderRadius.circular(12),
                     child: Container(
                       padding:EdgeInsets.all(5),
                       decoration: BoxDecoration(
                           border: Border.all(color:Color(0xFFE9E2E2) ),
                           borderRadius: BorderRadius.circular(12),
                       ),
                       child: Text(
                         "\u{20B9} 500",
                         style: AppWidget.semiBoldTextFields(),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     makePayement("1000");
                   },
                   child: Material(
                     elevation: 5,
                       borderRadius: BorderRadius.circular(12),
                     child: Container(
                       padding:EdgeInsets.all(5),
                       decoration: BoxDecoration(
                           border: Border.all(color:Color(0xFFE9E2E2) ),
                           borderRadius: BorderRadius.circular(12),
                       ),
                       child: Text(
                         "\u{20B9} 1000",
                         style: AppWidget.semiBoldTextFields(),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap:(){
                     makePayement("2000");
                   },
                   child: Material(
                     elevation: 5,
                       borderRadius: BorderRadius.circular(12),
                     child: Container(
                       padding:EdgeInsets.all(5),
                       decoration: BoxDecoration(
                           border: Border.all(color:Color(0xFFE9E2E2) ),
                           borderRadius: BorderRadius.circular(12)
                       ),
                       child: Text(
                         "\u{20B9} 2000",
                         style: AppWidget.semiBoldTextFields(),
                       ),
                     ),
                   ),
                 ),
               ],
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                RandomAmount();
              },
              child: Container(
                margin: EdgeInsets.only(left: 40,right: 40),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Add Money",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
