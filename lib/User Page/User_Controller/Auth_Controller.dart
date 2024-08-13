import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Admin Page/AdminHomepage.dart';
import '../BottomBar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Authentication extends ChangeNotifier{
  Future<Map<String, dynamic>> fetchUserDetails() async {
    User? user = auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User data not found');
    }
  }


  final TextEditingController UserNameController=TextEditingController();
  final TextEditingController EmailController=TextEditingController();
  final TextEditingController PasswordController=TextEditingController();
  final TextEditingController ConfirmPasswordController=TextEditingController();
  final TextEditingController PhoneController=TextEditingController();
  final FirebaseAuth authe = FirebaseAuth.instance;
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> clearLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }


  Register(context)async{
   try{
     String Email=EmailController.text.trim();
     String UserName=UserNameController.text.trim();
     String Password=PasswordController.text.trim();
     String Phone=PhoneController.text.trim();
     String ConfirmPassword=ConfirmPasswordController.text.trim();
     if(Password!=ConfirmPassword){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Password do not match'))
       );
       return;
     }
     UserCredential userCredential=await authe.createUserWithEmailAndPassword(email: Email,password: Password,);
     FirebaseFirestore firestore=FirebaseFirestore.instance;
     await firestore.collection("Users").doc(userCredential.user!.uid).set({
       'UserID': userCredential.user!.uid,
       'Email': Email,
       'UserName': UserName,
       'Phone': Phone,
     });
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Registration susscefful")),
     );
     EmailController.clear();
     PasswordController.clear();
     UserNameController.clear();
     PhoneController.clear();
     ConfirmPasswordController.clear();
   }catch(e){
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Failed to register: $e')),
     );
     EmailController.clear();
     PasswordController.clear();
     UserNameController.clear();
     PhoneController.clear();
     ConfirmPasswordController.clear();
   }
   notifyListeners();
  }




  Login(context)async{
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('isLoggedIn', true);
      await pref.setString('email', email);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('Users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData['Email'] == "sangeeth@1123.com") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in Successful"))
      );
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in: Enter your correct Email & password"))
      );
    }
    notifyListeners();
  }
}