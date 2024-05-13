import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth auth=FirebaseAuth.instance;

  Future<String> getCurrentUserDocumentId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final String uid = auth.currentUser!.uid;
    final CollectionReference usersCollection = firestore.collection('users');

    final DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    return userDoc.id;
  }

  Future SignOut()async{
    await FirebaseAuth.instance.signOut();
  }
  Future DeleteAccount()async{
    User? user=await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}