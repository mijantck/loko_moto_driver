import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loko_moto_driver/widgets/AlreadyResisterDialog.dart';
import 'package:loko_moto_driver/widgets/LoadingDialog.dart';
import 'package:loko_moto_driver/widgets/TaxiButton.dart';

import '../brand_colors.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';
import 'mainpage.dart';


class UserNamePage extends StatefulWidget {
    final String nameFromMLK;
    final String NIDFromMLK;
    UserNamePage(this.nameFromMLK,this.NIDFromMLK);
  @override
  _UserNamePageState createState() => _UserNamePageState(nameFromMLK,NIDFromMLK);

}

class _UserNamePageState extends State<UserNamePage> {
  _UserNamePageState(this.nameFromMLK, this.NIDFromMLK);

  String nameFromMLK;
  final String NIDFromMLK;
  Map<dynamic, dynamic> values;
  Set<String> numberSet = new  Set();


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String um, uid, una, username;
  File _image;
  final picker = ImagePicker();
  String UserVeryfite;

  String url = 'https://i.ibb.co/vvkJF5X/simpline.png';

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  static const String id = 'vehicleinfo';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();
  var _name = TextEditingController();

  void updateProfile(BuildContext context, String url1) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final uphone = user.phoneNumber.toString();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child(
        'drivers/${uid}');
    Map userMap = {
      'NID': NIDFromMLK,
      'fullname': _name.text,
      'phone': uphone,
      'ImageURL':url1,
    };
    dbRef.set(userMap);

    DatabaseReference driverRef =
    FirebaseDatabase.instance.reference().child('drivers/$uid/vehicle_details');

    Map map = {
      'car_color': carColorController.text,
      'car_model': carModelController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
          (Route<dynamic> route) => false,
    );
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    _name.value = TextEditingValue(text: nameFromMLK.replaceAll("Name:", ''));

    Future uploadPic(BuildContext context) async {

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("image1" + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      url = imageUrl.toString();
      print("ulr4: $url");

      updateProfile(context,url);

    }

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[

              SizedBox(height: 10,),
              Text('Enter vehicle details',
                style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),),

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.black12,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image != null) ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ) : Image.network(url,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  children: <Widget>[
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
                    SizedBox(height: 10,),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text("NID Number ", style: TextStyle(
                              fontFamily: 'Brand-Bold', fontSize: 15),),),
                          Expanded(child: Text(NIDFromMLK, style: TextStyle(
                              fontFamily: 'Brand-Bold', fontSize: 15),),),
                        ]
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
                      onPressed: () {
                        if (_name.text.length < 3) {
                          showSnackBar('Please provide name');
                          return;
                        }

                        if (carModelController.text.length < 3) {
                          showSnackBar('Please provide a valid car model');
                          return;
                        }

                        if (carColorController.text.length < 3) {
                          showSnackBar('Please provide a valid car color');
                          return;
                        }

                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar('Please provide a valid vehicle number');
                          return;
                        }


                        isUserRegistered("87807");
                          values?.forEach((key,values) {
                            print(values["NID"]);
                            numberSet.add(values["NID"].toString());
                          });

                          values.clear();

                        if (numberSet.contains(NIDFromMLK)) {
                          numberSet.clear();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlreadyResisterDialog()
                          );
                          return ;
                        } else {
                          numberSet.clear();

                          if(_image?.path != null){
                              showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => LoadingDialog()
                          );
                            uploadPic(context);
                          }else{
                            updateProfile(context,url);
                          }


                        }
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

  Future<String> isUserRegistered(String NIDToken) async {
   var  db = FirebaseDatabase.instance.reference().child("drivers");
   db.once().then((DataSnapshot snapshot){
     values = snapshot.value;
    });
  }
}
