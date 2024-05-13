
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Pages/login_page.dart';
import 'package:food_delivery/Pages/signUp_page.dart';
import 'package:food_delivery/Widgets/support_widgets.dart';
import 'Onboarding_Content.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {

  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller=PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount:contents.length ,
              onPageChanged: (int index){
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_,i){
              return Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      contents[i].image,
                      height:MediaQuery.of(context).size.height/2,fit: BoxFit.fill,
                    ),
                     SizedBox(height: 30,),
                    Text(contents[i].title,style: AppWidget.HeadLineTextFields(),),
                     SizedBox(height: 20,),
                    Text(contents[i].disccription,
                      style:  TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black54
                      ),
                    ),
            
                  ],
                ),
              );
            }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(contents.length, (index) => buildDot(index,context)
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if(currentIndex == (contents.length)-1){
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignupPage()));
                print(contents.length);
              }
              _controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(24)
              ),
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length-1 ? "Start" : "Next",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Container buildDot(int index,BuildContext context){
    return Container(
      height: 10,
      width: currentIndex == index ? 18 : 7,
      margin:  EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
