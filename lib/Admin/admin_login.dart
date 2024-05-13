import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Admin/home_admin.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController =TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // adminLogin Function -----

  LoginAdmin(){
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
      snapshot.docs.forEach((result){
        if(result.data()['id']!=userNameController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.up,
              margin: EdgeInsets.only(
                top: 30,
                bottom:MediaQuery.of(context).size.height-100,
              ),
              backgroundColor: Colors.white,
              content: const Text(
                "Enter correct user name.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          );
        }
        else if(result.data()['password']!=passwordController.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.up,
              margin: EdgeInsets.only(
                top: 30,
                bottom:MediaQuery.of(context).size.height-100,
              ),
              backgroundColor: Colors.white,
              content: const Text(
                "Enter correct password.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          );
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeAdminPage(),));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFE5E8EA),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(topLeft:Radius.circular(40),topRight: Radius.circular(40)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:60,left: MediaQuery.of(context).size.width*0.07,right: MediaQuery.of(context).size.width*0.07),
            child: Column(
              children: [
                Text("Let's start with Admin!",style: AppWidget.HeadLineTextFields(),),
                const SizedBox(height: 50,),
                Material(
                  borderRadius: BorderRadius.circular(40),
                  elevation: 5,
                  shadowColor: Colors.lightBlueAccent,
                  child: Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: TextFormField(
                            controller: userNameController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Please Enter UserName";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "username",
                                hintStyle: TextStyle(color: Colors.black38),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.only(left: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter password";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "password",
                                hintStyle: TextStyle(color: Colors.black38),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () {
                            LoginAdmin();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                "LogIn",style:TextStyle(fontWeight:FontWeight.bold,fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
