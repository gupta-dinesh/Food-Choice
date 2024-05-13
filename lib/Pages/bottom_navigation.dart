import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/HomePage.dart';
import 'package:food_delivery/Pages/OrderPage.dart';
import 'package:food_delivery/Pages/Profile.dart';
import 'package:food_delivery/Pages/wallet.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
   int currentTabIndex=0;
   late List<Widget> pages;
   late Widget currentPage;
   late HomePage home_Page;
   late WalletPage wallet;
   late OrderPage order;
   late ProfilePage profile;

   @override
  void initState() {
     home_Page=HomePage();
     order=OrderPage();
     wallet=WalletPage();
     profile=ProfilePage();
     pages=[home_Page,order,wallet,profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(
        height: 47,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            currentTabIndex=index;
          });
        },
        items: const[
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
              Icons.shopping_cart_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.wallet_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
        ],
      ),
      body:pages[currentTabIndex],
    );
  }
}
