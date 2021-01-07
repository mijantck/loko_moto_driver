import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loko_moto_driver/screens/login.dart';
import 'package:loko_moto_driver/screens/mainpage.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    if(user == null){
      return LoginScreen();
    }else{
      print('fuck');
      return MainPage();

    }
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }


  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);

  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}