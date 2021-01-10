import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loko_moto_driver/datamodels/directiondetails.dart';
import 'package:loko_moto_driver/datamodels/history.dart';
import 'package:loko_moto_driver/globalvariabels.dart';
import 'package:loko_moto_driver/helpers/requesthelper.dart';
import 'package:loko_moto_driver/widgets/ProgressDialog.dart';
import 'package:provider/provider.dart';

import '../dataprovider.dart';

class HelperMethods{


  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapkey';

    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFares (DirectionDetails details, int durationValue){
    // per km = $0.3,
    // per minute = $0.2,
    // base fare = $3,

    double baseFare = 3;
    double distanceFare = (details.distanceValue/1000) * 0.3;
    double timeFare = (durationValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();

  }

  static void disableHomTabLocationUpdates(){
    homeTabPositionStream.pause();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uidu = user.uid;
    Geofire.removeLocation(uidu);
  }

  static void enableHomTabLocationUpdates(){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uidu = user.uid;

    homeTabPositionStream.resume();
    Geofire.setLocation(uidu, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context){

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Please wait',),
    );
  }

  static void getHistoryData(context){

    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys){
      DatabaseReference historyRef = FirebaseDatabase.instance.reference().child('rideRequest/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if(snapshot.value != null){

          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistory(history);

          print(history.destination);
        }
      });
    }

  }

  static String formatMyDate(String datestring){

    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

}
