import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loko_moto_driver/widgets/AvailabilityButton.dart';
import 'package:loko_moto_driver/widgets/ConfirmSheet.dart';

import '../brand_colors.dart';
import '../globalvariabels.dart';
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  DatabaseReference tripRequestRef;

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;


  void getCurrentPosition() async {

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));

  }

  void getCurrentDriverInfo () async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child(
        'drivers/${currentFirebaseUser.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: GooglePlex,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),

        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvailabilityButton(
                title: availabilityTitle,
                color: availabilityColor,
                onPressed: (){


                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable) ? 'You are about to become available to receive trip requests': 'you will stop receiving new trip requests',

                      onPressed: (){

                        if(!isAvailable){
                          GoOnline();
                          Navigator.pop(context);


                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'GO OFFLINE';
                            isAvailable = true;
                          });

                        }
                        else{
                          GoOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitle = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }

                      },
                    ),
                  );

                },
              ),
            ],
          ),
        )

      ],
    );
  }

  void GoOnline(){

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uidu = user.uid;
    Position currentPosition = new Position();

    print('${currentPosition.longitude}  +kkk');

    Geofire.initialize('driversAvailable');

    Geofire.setLocation(uidu, 24.222732, 90.169622);

    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${uidu}/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {

    });

  }

  void GoOffline (){
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uidu = user.uid;

    Geofire.removeLocation(uidu);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;

  }

}
