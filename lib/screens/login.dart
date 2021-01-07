import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loko_moto_driver/widgets/country_picker.dart';
import '../widgets/country_picker.dart';
import 'otp.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  var _dialCode = '';

  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),


            Container(
                margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.0)),
                child:Row(
                  children: [
                    CountryPicker(
                      callBackFunction: _callBackFunction,
                      headerText: 'Select Country',
                      headerBackgroundColor: Theme.of(context).primaryColor,
                      headerTextColor: Colors.white,
                    ),
                    SizedBox(width:3.0,),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Contact Number',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13.5),
                        ),
                        controller: _controller,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    /* TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller,
                  ),*/

                  ],
                )

            )
          ]),


          Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OTPScreen(_dialCode+''+_controller.text)));
                  // Respond to button press
                },
                child: Text("GET OTP",),
              )
          )
        ],
      ),
    );
  }
}