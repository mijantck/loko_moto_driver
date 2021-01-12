import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loko_moto_driver/screens/cameraScreen.dart';
import 'package:loko_moto_driver/screens/login.dart';
import 'package:loko_moto_driver/screens/mainpage.dart';
import 'package:loko_moto_driver/services/authservice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'image_detail.dart';

import 'dataprovider.dart';
import 'globalvariabels.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS
        ? FirebaseOptions(
      appId: '1:850491199363:ios:ef05b68f3d980a252eb0b6',
      apiKey: 'AIzaSyDroiqvQRcGrKgYwT5TjKSxyUsPFTV9mN0',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '850491199363',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:850491199363:android:b8c8aec4f9a5f46d2eb0b6',
      apiKey: 'AIzaSyAeBwhCv9Uo1NkgAV0jMtrbxKOK6Jix7fc',
      messagingSenderId: '850491199363',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://lokomoto-c7830-default-rtdb.firebaseio.com',
    ),
  );
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: CameraScreen(),
          //AuthService().handleAuth(),
        )
    );


  }
}





