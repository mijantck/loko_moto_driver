import 'package:flutter/material.dart';

import '../brand_colors.dart';
import 'TaxiOutlineButton.dart';

class LoadingDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),

                Text('please waite same time...', style: TextStyle(fontSize: 18.0, fontFamily: 'Brand-Bold'),),


              ],
            ),
          ),
        ),
      ),
    );
  }
}