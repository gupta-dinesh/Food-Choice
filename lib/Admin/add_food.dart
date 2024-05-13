import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Service/database.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {

  final List<String> FoodItems =['Ice-Cream','Burger','Pizza','Cakes'];
  String ? value;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final ImagePicker _picker =ImagePicker();
  File? selectImage;
// Function to choose image from gallery
  Future getImage() async{
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectImage = File(image!.path);
    setState(() {

    });
  }

  // fucntion to upload items on firebase ---->

  uploadItem() async{
    if(selectImage!=null && nameController.text!="" && priceController.text!="" && detailsController.text!=""){
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectImage!,SettableMetadata(contentType: 'image/png'));

      var downloadUrl = await(await task).ref.getDownloadURL();
      Map<String,dynamic> addItem = {
        "Image": downloadUrl,
        "Name":nameController.text,
        "Price":priceController.text,
        "Details":detailsController.text,

      };
      await DatabaseMethod().addFoodItems(addItem, value!).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            dismissDirection: DismissDirection.up,
            margin: EdgeInsets.only(
              top: 20,
              bottom:MediaQuery.of(context).size.height-100,
            ),
            backgroundColor: Colors.black,
            content: Text(
              "Food item has been added successfully",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,)
        ),
        title: Text("Add Item",style: AppWidget.semiBoldTextFields(),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 15,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload the item picture",style: AppWidget.semiBoldTextFields(),),
              SizedBox(height: 20,),
              selectImage == null
              ? GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Center(
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                          color: Color(0xFFE5E8EA),
                        ),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  ),
              )
              : Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFFE5E8EA),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Item Name",style: AppWidget.semiBoldTextFields(),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width:MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E8EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter item name",
                    hintStyle: AppWidget.LightTextFields(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Item Price",style: AppWidget.semiBoldTextFields(),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width:MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E8EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter item price",
                    hintStyle: AppWidget.LightTextFields(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Item Details",style: AppWidget.semiBoldTextFields(),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width:MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E8EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines:4,
                  controller: detailsController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter item details",
                    hintStyle: AppWidget.LightTextFields(),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text("Select Category",style: AppWidget.semiBoldTextFields(),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E8EA),
                  borderRadius:  BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: FoodItems.map((item) => DropdownMenuItem<String>(
                      value: item,
                        child: Text(item,style: TextStyle(fontSize: 18,color: Colors.black),))).toList(),
                    onChanged: ((value) => setState(() {
                      this.value=value;
                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Center(
                      child: Text(
                        "Add",style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
