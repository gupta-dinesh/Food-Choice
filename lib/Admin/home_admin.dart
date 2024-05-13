import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Admin/add_food.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Home Admin",style: AppWidget.HeadLineTextFields(),),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(12)
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddFoodPage(),));
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/images/pizza_type1.jpg",height: 100,width: 100,fit: BoxFit.cover,)),
                    ),
                    SizedBox(width: 30,),
                    Text("Add food items",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
