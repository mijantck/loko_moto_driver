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

  @override
  _UserNamePageState createState() => _UserNamePageState();

}

class _UserNamePageState extends State<UserNamePage> {
  _UserNamePageState();

  Map<dynamic, dynamic> values;
  Set<String> numberSet = new  Set();


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String um, uid, una, username;
  File _image;
  File _imageNID;
  File imageLIST;
  final picker = ImagePicker();
  String UserVeryfite;

  String url = 'https://i.ibb.co/vvkJF5X/simpline.png';
  String urlNID = 'https://i.ibb.co/vvkJF5X/simpline.png';

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
  var NIDNumber = TextEditingController();

  void updateProfile(BuildContext context, String url1,String url1NID) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final uphone = user.phoneNumber.toString();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child(
        'drivers/${uid}');
    Map userMap = {
      'NID': NIDNumber.text,
      'fullname': _name.text,
      'phone': uphone,
      'ImageURL':url1,
      'ImageURLND':url1NID,
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
  Future getImageNID() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageNID = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
  //  _name.value = TextEditingValue(text: nameFromMLK.replaceAll("Name:", ''));
    Future uploadPic(BuildContext context) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      int i1 = 1;
      for(var i = 0 ; i <= 1; i++){
        if(i == 0){
          print('starrt');
          Reference ref = storage.ref().child("image1" + DateTime.now().toString());
          UploadTask uploadTask = ref.putFile(_image);
          var imageUrl = await (await uploadTask).ref.getDownloadURL();
          url = imageUrl.toString();
          print("ulr4: $url");
          i1 = 1;
          print('starrt $i1');
        }else if(i == 1){
          Reference ref = storage.ref().child("image1" + DateTime.now().toString());
          UploadTask uploadTask = ref.putFile(_imageNID);
          var imageUrl = await (await uploadTask).ref.getDownloadURL();
          urlNID = imageUrl.toString();
          print("ulr4: $urlNID");
          i1 = 2;
          print('starrt $i1');
        }
      }
      if(i1 == 2){
        updateProfile(context,url,urlNID);
      }


    }

    showLoaderDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
          ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }



    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[

              SizedBox(height: 10,),
              Text('Your Information details',
                style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 22),),

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black12,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 100.0,
                          height: 100.0,
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

              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Container(
                  width: 200.0,
                  height: 100.0,
                  child: new SizedBox(
                    width: 200.0,
                    height: 100.0,
                    child: (_imageNID != null) ? Image.file(
                      _imageNID,
                      fit: BoxFit.fill,
                    ) : Image.network("https://i.ibb.co/PmCRnzN/smart-card.jpg",
                      fit: BoxFit.fill,
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
                          getImageNID();

                        },
                      ),
                    ),
                    ]
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
                    TextField(
                      controller: NIDNumber,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'NID Number ',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10,),

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
                        if (NIDNumber.text.length < 9) {
                          showSnackBar('Please provide a valid NID number');
                          return;
                        }
                        if (_imageNID?.path == null) {
                          showSnackBar('Please provide a NID Image');
                          return;
                        }
                        if (_image?.path == null) {
                          showSnackBar('Please provide a profile Image');
                          return;
                        }


                        isUserRegistered("87807");
                          values?.forEach((key,values) {
                            print(values["NID"]);
                            numberSet.add(values["NID"].toString());
                          });

                          values?.clear();

                        if (numberSet.contains(NIDNumber.text)) {
                          numberSet.clear();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlreadyResisterDialog()
                          );
                          return ;
                        } else {
                          numberSet.clear();
                          if(_image?.path != null && _imageNID?.path != null){

                            showLoaderDialog(context);
                            uploadPic(context);
                          }else{

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
