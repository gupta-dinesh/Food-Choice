import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Pages/Onboard.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Service/shared_prefrence.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:food_delivery/Service/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String ? id,profile,name,email;

  gettheData()async{
    //profile = await DatabaseMethod().getUserImage();
    id=await  AuthMethods().getCurrentUserDocumentId();
    name = await DatabaseMethod().getUserName(id!);
    email = await DatabaseMethod().getUserEmail(id!);
    setState(() {
    });
  }

  onTheLoad()async{
    await gettheData();
    setState(() {
    });
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  final ImagePicker _picker =ImagePicker();
  File? selectImage;
// Function to choose image from gallery
  Future getImage() async{
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectImage = File(image!.path);
    setState(() {
      uploadImage();
    });
  }

  // fucntion to upload image on firebase ---->

  uploadImage() async{
    if(selectImage!=null){
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectImage!,SettableMetadata(contentType: 'image/png'));

      var downloadUrl = await(await task).ref.getDownloadURL();
      await SharedPrefrenceHelper().saveUserProfile(downloadUrl);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:name == null? Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,))
       : Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 45,left: 20,right: 20),
                  height: MediaQuery.of(context).size.height/4.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100)
                    )
                  ),
                ),
                Center(
                  child: Container(
                    margin:EdgeInsets.only(top: MediaQuery.of(context).size.height/6.5) ,
                    child: Material(
                      elevation:10 ,
                      borderRadius: BorderRadius.circular(60),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: selectImage == null
                            ? GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: profile== null
                                    ? Image.asset("assets/images/profile.png",height: 120,width: 120,fit: BoxFit.cover,)
                                    : Image.network(profile!,height: 120,width: 120,fit: BoxFit.cover,),
                              )
                            : Image.file(selectImage!,height: 120,width: 120,fit:BoxFit.cover,)
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(
                      name!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline,color: Colors.black,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                                color:Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            name!,
                            style: const TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.email_outlined,color: Colors.black,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            email!,
                            style: const TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.description,color: Colors.black,),
                      SizedBox(width: 20,),
                      Text(
                        "Terms and Conditions",
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),

              ),
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Are Sure to delete the account?",
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
                          TextButton(
                            onPressed: () async {
                              await AuthMethods().DeleteAccount();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboard(),));
                              showDialog(
                                context: context,
                                builder: (_) {
                                  Future.delayed(Duration(milliseconds:1000),(){
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
                                          Center(
                                            child: Text("Account is deleted successfully.",
                                              style:TextStyle(fontWeight: FontWeight.bold),
                                              //maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                                },);
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
                    },);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const  Row(
                      children: [
                        Icon(Icons.delete,color: Colors.black,),
                        SizedBox(width: 20,),
                        Text(
                          "Delete Account",
                          style: TextStyle(
                            color:Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(milliseconds:1000),(){
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      content: const Text("Are Sure to Signout?",
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
                        TextButton(
                          onPressed: () async{
                            await AuthMethods().SignOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Onboard()));
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
                                          Text("Signed out successfully.",
                                            style:TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),);

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
                  },);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.logout,color: Colors.black,),
                        SizedBox(width: 20,),
                        Text(
                          "LogOut",
                          style: TextStyle(
                            color:Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
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
