import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Pages/details.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'package:food_delivery/Pages/bottom_navigation.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _myController = ScrollController();

  bool icecream=false,pizza=false,burger=false,cakes=false;

  // getting the item data from firebase --
  Stream? foodItemStream;
  onTheLoad()async{
    foodItemStream = await DatabaseMethod().getFoodItem("Pizza");
    setState(() {

    });
  }
  @override
  void initState() {
    onTheLoad();
    super.initState();
  }
// items from firebase show horizontally scrollable--->
  Widget allItems(){
    return StreamBuilder(stream: foodItemStream, builder:(context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            DocumentSnapshot ds =snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return DetailsPage(
                    name: ds["Name"],
                    details: ds["Details"],
                    price: ds["Price"],
                    image: ds["Image"],
                  );
                }));
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    //padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(ds['Image'],
                            height: 150,width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(ds["Name"],
                          style: AppWidget.semiBoldTextFields(),),
                        Text("Fast Food",
                          style: AppWidget.LightTextFields(),),
                        Text("\u{20B9}"+ds["Price"],style: AppWidget.semiBoldTextFields(),)
                      ],),
                  ),
                ),
              ),
            );

      }):Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,));
    });
  }

  //items from firebase show vertically scrollable --->
  Widget allItemsVertically(){
    return StreamBuilder(stream: foodItemStream, builder:(context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index){
            DocumentSnapshot ds =snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(
                  name: ds["Name"],
                  details: ds["Details"],
                  price: ds["Price"],
                  image: ds["Image"],
                ),));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(ds['Image'],
                            height: 120,width: 120,fit: BoxFit.cover,),
                        ),
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(ds["Name"],
                                  style: AppWidget.semiBoldTextFields()),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text("Fresh,Testy and Delicious",
                                style: AppWidget.LightTextFields(),),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text("\u{20B9}"+ds["Price"],
                                  style: AppWidget.boldTextFields()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          }):Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          margin: EdgeInsets.only(top: 50,left: 10,right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Dinesh,",
                    style:AppWidget.boldTextFields(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 1,),
              Text("Get your favorite food items",style: AppWidget.LightTextFields(),),
              SizedBox(height: 20,),
              showItems(),
              SizedBox(height: 20,),

              // called allItems() horizontally ---->
              Container(
                height: 250,
                  child: allItems()),
              SizedBox(height: 20,),
            ],
          ),
        ),
          Container(
            margin: EdgeInsets.only(top: 460,right: 10,left: 10),
            child: allItemsVertically(),
          )
        ],
      ),
    );
  }
  //Items to show
  Widget showItems(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        GestureDetector(
          onTap: () async{
            burger=true;
            pizza=false;
            icecream=false;
            cakes=false;
            foodItemStream =await DatabaseMethod().getFoodItem("Burger");
            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: burger?Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset("assets/images/burger.png",height: 50,width: 50,fit:BoxFit.cover,color:burger? Colors.white :Colors.black),
            ),

          ),
        ),
        GestureDetector(
          onTap: () async{
            burger=false;
            pizza=true;
            icecream=false;
            cakes=false;
            foodItemStream =await DatabaseMethod().getFoodItem("Pizza");
            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: pizza?Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset("assets/images/Pizza.png",height: 50,width: 50,fit:BoxFit.cover,color:pizza? Colors.white :Colors.black),
            ),

          ),
        ),
        GestureDetector(
          onTap: () async {
            burger=false;
            pizza=false;
            icecream=true;
            cakes=false;
            foodItemStream =await DatabaseMethod().getFoodItem("Ice-Cream");
            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: icecream?Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset("assets/images/IceCream.png",height: 50,width: 50,fit:BoxFit.cover,color:icecream? Colors.white :Colors.black),
            ),

          ),
        ),
        GestureDetector(
          onTap: () async{
            burger=false;
            pizza=false;
            icecream=false;
            cakes=true;
            foodItemStream =await DatabaseMethod().getFoodItem("Cakes");
            setState(() {

            });
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: cakes?Colors.black:Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset("assets/images/cakes.png",height: 50,width: 50,fit:BoxFit.cover,color:cakes? Colors.white :Colors.black),
            ),

          ),
        ),
      ],
    );
  }
}
