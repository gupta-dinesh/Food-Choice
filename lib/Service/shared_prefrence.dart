import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery/Pages/signUp_page.dart';

class SharedPrefrenceHelper{
  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userWalletKey="USERWALLETKEY";
  static String userProfileKey="USERPROFILEKEY";

  // SharedPreferences :- providing a persistent store for simple data.

  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }
  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveUserWallet(String getUserWallet) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, getUserWallet);
  }
  Future<bool> saveUserProfile(String getUserProfile) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  // setString :- Saves a string value to persistent storage in the background.
  //getString :- Reads a value from persistent storage, throwing an exception if it's not a String.
  // persitent storage :  local storage

  Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
  Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
  Future<String?> getUserEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
  Future<String?> getUserWallet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }
  Future<String?> getUserProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

}