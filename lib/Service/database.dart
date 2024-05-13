import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethod{
  Future addUser(Map<String,dynamic> userInfo) async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .set(userInfo);
  }
  UpdateUserWallet(String id,String amount) async{
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet":amount});
  }
  Future<String> getWalletMoney(String id)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String,dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
    return data['Wallet'];
  }
  Future<String> getUserName(String id)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String,dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
    return data['Name'];
  }
  Future<String> getUserEmail(String id)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    Map<String,dynamic> data = documentSnapshot.data() as Map<String,dynamic>;
    return data['Email'];
  }

  Future addFoodItems(Map<String,dynamic> itemInfo,String name) async{
    await FirebaseFirestore.instance
        .collection(name)
        .add(itemInfo);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async{
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }
  Future addFoodToCart(Map<String,dynamic> cartInfo,String id,String cartItemId) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id).collection("Cart")
        .doc(cartItemId)
        .set(cartInfo);
  }
  Future<Stream<QuerySnapshot>> getFoodCart(String id) async{
    return await FirebaseFirestore.instance.collection('users').doc(id).collection("Cart").snapshots();
  }
  DeleteFromCart(String userId,String itemId) async{
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId).collection("Cart")
        .doc(itemId)
        .delete();
  }
  Future<int> cartTotalPrice(String userId) async{
    int totalPrice=0;
    final cartItemsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart');
    final QuerySnapshot cartItemsSnapshot = await cartItemsRef.get();
    cartItemsSnapshot.docs.forEach((cartItemDoc) {
      final int itemPrice = int.parse(cartItemDoc['Total']);
      totalPrice += itemPrice;
    });
    return totalPrice;
  }

}