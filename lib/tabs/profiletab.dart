import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../dataprovider.dart';
import '../globalvariabels.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  TextEditingController _name = TextEditingController();
  TextEditingController _nameView = TextEditingController();
  String username;


  File _image;
  String url;

  bool visibilityUserNameEditore = false;
  bool visibilityUserName = true;
  bool SubmiteButton = false;
  bool ImgeButtonClick = false;
  String userName = currentDriverInfo.fullName;
  String carModle = currentDriverInfo.carModel;
  String carColor = currentDriverInfo.carColor;



  @override
  Widget build(BuildContext context) {
    var pickup = Provider.of<AppData>(context, listen: false);

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      String uid = user.uid;
      final uphone = user.phoneNumber.toString();
      DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${uid}');

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(uid).child("image" + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(_image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      url = imageUrl.toString();
      print("ulr4: $url");

      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });

      Map userMap = {
        'fullname': (username?.length > 0 ) ? username : currentDriverInfo.fullName,
        'imageURI':url,
        'phone':uphone,
      };
      dbRef.set(userMap);


    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Edit Profile'),
        ),
        body:SingleChildScrollView(
          child: Builder(
            builder: (context) =>  Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  //image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Color(0xff476cfb),
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image!=null)?Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ):Image.network(currentDriverInfo.ImageURL,
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
                            setState(() {
                              SubmiteButton = true;

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //username
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Visibility(
                                visible: true,
                                child:  Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Username',
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 18.0)),
                                ),
                              ),

                              Visibility(
                                visible:visibilityUserName,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(userName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                visibilityUserNameEditore = true;
                                visibilityUserName = false;
                                SubmiteButton = true;

                              });

                            },
                            child:  Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.pen,
                                  color: Color(0xff476cfb),
                                ),
                              ),
                            ),
                          )
                      ),

                    ],
                  ),
                  Container(
                      margin: EdgeInsets.all(5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Visibility(
                              visible: visibilityUserNameEditore,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter Name ',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: _name,
                                    onChanged: (val) {
                                      setState(() {
                                        this.username = val;
                                      }
                                      );
                                    },
                                  )),
                            )
                          ]
                      )

                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Car Color and Model',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 18.0)),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("${currentDriverInfo.carColor} and ${currentDriverInfo.carModel} ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Phone ',
                            style:
                            TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                        SizedBox(width: 20.0),
                        Text(currentDriverInfo.phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Visibility(
                        visible: SubmiteButton ,
                        child: RaisedButton(
                          color: Color(0xff476cfb),
                          onPressed: () {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            final User user = auth.currentUser;
                            String uid = user.uid;
                            final uphone = user.phoneNumber.toString();
                            if(ImgeButtonClick == false){
                              DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('drivers/${uid}/fullname');
                              dbRef.set(username);
                              setState(() {
                                userName = username;
                              });
                            }else{
                              uploadPic(context);
                            }
                            setState(() {
                              visibilityUserNameEditore = false;
                              visibilityUserName = true;

                            });
                          },
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}