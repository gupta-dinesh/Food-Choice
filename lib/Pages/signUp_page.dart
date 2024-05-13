import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Admin/admin_login.dart';
import 'package:food_delivery/Pages/bottom_navigation.dart';
import 'package:food_delivery/Pages/login_page.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Service/shared_prefrence.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String email ="", password ="", name="";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formkey=GlobalKey<FormState>();//i want to check user is entered all things is right or not

  // registraion function

  registration()async{
    if(password != null){
      try{
        UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        Timer(Duration(seconds: 1),(){
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
                      Text("Registered successfully.",
                        style:TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ],
                  )
                ],
              ),
            ),);
        });
        //Upload user data to firestore database ---->
        Map<String,dynamic> addUserInfo = {
          "Name" : nameController.text,
          "Email" :emailController.text,
          "Wallet":"0",
          //"id" :id,
        };
        await DatabaseMethod().addUser(addUserInfo);
        //await SharedPrefrenceHelper().saveUserId(id!);
        await SharedPrefrenceHelper().saveUserName(nameController.text);
        await SharedPrefrenceHelper().saveUserEmail(emailController.text);
        await SharedPrefrenceHelper().saveUserWallet("0");


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>BottomNavigation(),));
      }on FirebaseException catch(e){
        if(e.code == "weak-password"){
          print("Password is weak.");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                margin: EdgeInsets.only(
                  top: 20,
                  bottom:MediaQuery.of(context).size.height-100,
                ),
                backgroundColor: Colors.white,
                content: const Text(
                  "Provided password is weak!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
          );
        }
        else if(e.code == "email-already-in-use"){
          print("Account alreayd exists for that email.");
          Timer(Duration(seconds: 1),(){
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
                            Icons.account_circle_outlined,
                            color: Colors.green,
                          ),
                        ),
                        Text("Account already exists.",
                          style:TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ],
                    )
                  ],
                ),
              ),);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors:[
                      Colors.lightBlueAccent,
                      Colors.blue,
                    ],
                    begin:Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30,left: MediaQuery.of(context).size.width*0.07,right: MediaQuery.of(context).size.width*0.07),
              child: Column(
                children: [
                  Center(
                    child: Image.asset("assets/images/Food Delivery Logo.png",width: MediaQuery.of(context).size.width/3,fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 50,),
                  Material(
                    elevation: 20,
                    shadowColor:Colors.blue ,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      margin: EdgeInsets.only(right: 20,left: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Text("SignUp",style: AppWidget.boldTextFields(),),
                            SizedBox(height: 5,),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Please enter your name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintStyle: AppWidget.semiBoldTextFields(),
                                hintText: "Name",
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Enter correct E-mail";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintStyle: AppWidget.semiBoldTextFields(),
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  return "Please enter the password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.password),
                                hintStyle: AppWidget.semiBoldTextFields(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 30,),
                            GestureDetector(
                              onTap: () async{
                                if(_formkey.currentState!.validate()){
                                  setState(() {
                                    name =nameController.text;
                                    email = emailController.text;
                                    password=passwordController.text;
                                  });
                                }
                                registration();
                              },
                              child: Material(
                                elevation: 10,
                                shadowColor: Colors.blue,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.lightBlueAccent,
                                  ),
                                  child: Center(
                                    child: Text(
                                        "SignUp",
                                        style: AppWidget.semiBoldTextFields()
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        const Text("         Already have an account ?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.lightBlueAccent
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin(),));
                      },
                      child: const Text(
                        "Are you an Admin ?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent
                        ),
                      ),),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
