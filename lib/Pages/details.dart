import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Pages/OrderPage.dart';
import 'package:food_delivery/Service/auth.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Service/shared_prefrence.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'package:food_delivery/Pages/signUp_page.dart';
import 'package:random_string/random_string.dart';


class DetailsPage extends StatefulWidget {
  String image,name,details,price;
  DetailsPage({
    required this.details,
    required this.name,
    required this.image,
    required this.price
});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  int quantity=1;
  String totalPrice="0";
  String ? id;
  gettheSharedsharedpref()async{
    id=await AuthMethods().getCurrentUserDocumentId();
    setState(() {});
  }

  ontheload()async{
    await gettheSharedsharedpref();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Item Details",
          style: AppWidget.boldTextFields(),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.image,//widget.image
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2.5,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child:Text(widget.name,maxLines: 2,style: AppWidget.HeadLineTextFields(),),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10),),
                    child: GestureDetector(
                      onTap: () {
                        if(quantity>1){
                          --quantity;
                        }
                        setState(() {
                        });
                      },
                        child: Icon(Icons.remove,color: Colors.white,),
                    ),
                  ),
                  Text(quantity.toString(),style: AppWidget.semiBoldTextFields(),),
                  Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10),),
                    child: GestureDetector(
                      onTap: () {
                          ++quantity;
                          setState(() {
                          });
                      },
                        child: Icon(Icons.add,color: Colors.white,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Text(widget.details,
                style: AppWidget.LightTextFields(),
                maxLines: 4,
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text("Delivery Time",style: AppWidget.semiBoldTextFields(),),
                  SizedBox(width: 30,),
                  Icon(Icons.alarm,color: Colors.black54,),
                  Text("30 min",style: AppWidget.semiBoldTextFields(),),
                ],
              ),
              SizedBox(height: 40,),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Price",style: AppWidget.HeadLineTextFields(),),
                        Text("\u{20B9} "+((int.parse(widget.price))*quantity).toString(),style: AppWidget.HeadLineTextFields(),),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async{
                        String cartItemId=randomAlphaNumeric(10);
                        Map<String,dynamic> addFoodtoCart={
                          "Name":widget.name,
                          "Quantity":quantity.toString(),
                          "Total":((int.parse(widget.price))*quantity).toString(),
                          "Image":widget.image,
                          "ItemId":cartItemId.toString()
                        };
                        await DatabaseMethod().addFoodToCart(addFoodtoCart, id!,cartItemId);
                        // To show the popup that item added to cart
                        showDialog(
                          context: context,
                          builder: (_) {
                            Future.delayed(Duration(milliseconds: 500),(){
                              Navigator.of(context).pop(true);
                            });
                            return const AlertDialog(
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
                                    Text("Item added to cart successfully",
                                      style:TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                          },);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black,
                        ),
                        child: Row(
                          children: [
                            Text("Add To Cart",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                            SizedBox(width: 10,),
                            Icon(Icons.shopping_cart_outlined,color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
      ),
    );
  }
}
