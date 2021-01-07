import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loko_moto_driver/widgets/TaxiButton.dart';
import '../brand_colors.dart';
import '../services/authservice.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mainpage.dart';


class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();

}

class _UserNamePageState extends State<UserNamePage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String um,uid,una,username;
  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static const String id = 'vehicleinfo';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();
  var _name = TextEditingController();

  void updateProfile(context){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final uphone = user.phoneNumber.toString();

    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('drivers/${uid}');
    Map userMap = {
      'fullname': username,
      'phone': uphone,
    };
    dbRef.set(userMap);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);

    DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child('drivers/$uid/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[

              SizedBox(height: 30,),

              Image.asset('images/logo.png', height: 100, width: 100,),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: <Widget>[

                    SizedBox(height: 10,),

                    Text('Enter vehicle details', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),),

                    SizedBox(height: 25,),

                    TextField(
                      controller: _name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Name ',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Car model',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0),

                    TextField(
                      controller: carColorController,
                      decoration: InputDecoration(
                          labelText: 'Car color',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 10.0),

                    TextField(
                      controller: vehicleNumberController,
                      maxLength: 11,
                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Vehicle number',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 40.0),

                    TaxiButton(
                      color: BrandColors.colorGreen,
                      title: 'PROCEED',
                      onPressed: (){


                        if(_name.text.length < 3){
                          showSnackBar('Please provide name');
                          return;
                        }

                        if(carModelController.text.length < 3){
                          showSnackBar('Please provide a valid car model');
                          return;
                        }

                        if(carColorController.text.length < 3){
                          showSnackBar('Please provide a valid car color');
                          return;
                        }

                        if(vehicleNumberController.text.length < 3){
                          showSnackBar('Please provide a valid vehicle number');
                          return;
                        }

                        updateProfile(context);

                      },
                    )


                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

void usernameChecker(){
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  String uid = user.uid;
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${uid}');
  dbRef.once().then((DataSnapshot snapshot) {
    if(snapshot.value != null){
      return MainPage();
    }else{
      return UserNamePage();
    }
  });
}