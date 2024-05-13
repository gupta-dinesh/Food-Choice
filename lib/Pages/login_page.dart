import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Pages/bottom_navigation.dart';
import 'package:food_delivery/Pages/details.dart';
import 'package:food_delivery/Pages/forgot_password.dart';
import 'package:food_delivery/Pages/signUp_page.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email = "",password ="";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation(),));
    }on FirebaseAuthException catch(e){
      if(e.code== "user-not-found"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            margin: EdgeInsets.only(
              top: 20,
              bottom:MediaQuery.of(context).size.height-100,
            ),
            backgroundColor: Colors.white,
            content: Text(
              "NO user found for that Email !",
              style: TextStyle(
                fontSize: 18,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        );
      }
      else if(e.code == "wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            margin: EdgeInsets.only(
              top: 20,
              bottom:MediaQuery.of(context).size.height-100,
            ),
            backgroundColor: Colors.white,
            content: Text(
              "Entered password is wrong!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        );
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
              decoration: BoxDecoration(
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
              decoration: BoxDecoration(
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
                          key:_formKey,
                          child: Column(
                            children: [
                              Text("Login",style: AppWidget.boldTextFields(),),
                              SizedBox(height: 30,),
                              TextFormField(
                                controller: emailController,
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return "Please Enter the email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: AppWidget.semiBoldTextFields(),
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              SizedBox(height: 30,),
                              TextFormField(
                                controller: passwordController,
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return "Enter the password";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.password),
                                  hintStyle: AppWidget.semiBoldTextFields(),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 30,),
                              Container(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                                  },
                                  child: Text("Forgot Password?",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),),
                                ),
                              ),
                              SizedBox(height: 30,),
                              GestureDetector(
                                onTap: () {
                                  if(_formKey.currentState!.validate()){
                                    setState(() {
                                      email =emailController.text;
                                      password =passwordController.text;
                                    });
                                  }
                                  userLogin();
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
                                        "Login",
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
                    SizedBox(height: 30,),
                    Container(
                      alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text("         Don't have an account?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                              },
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.lightBlueAccent
                                ),
                              ),
                            )
                          ],
                        ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
