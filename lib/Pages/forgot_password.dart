import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailController =TextEditingController();
  String email="";

  final _FormKey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
                "Password reset email has been sent !",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
          ),
      );
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                  "No user found for that email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                  "Password Recovery",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text(
              "Enter your email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
                child: Form(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            key: _FormKey,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            controller: emailController,
                            validator: (value){
                              if(value==null || value.isEmpty){
                                return "Enter your email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: 18,color: Colors.white),
                              prefixIcon: Icon(Icons.email_outlined,color: Colors.white,),

                              border: OutlineInputBorder(
                                borderRadius:BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          margin: EdgeInsets.only(left:10,right: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:  GestureDetector(
                            onTap: () {
                              if(emailController.text != null || emailController.text.isNotEmpty){
                                setState(() {
                                  email=emailController.text;
                                });
                                resetPassword();
                              }
                            },
                            child:  Center(
                              child: Text(
                                  "Send Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
