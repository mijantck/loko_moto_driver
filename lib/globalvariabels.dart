import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapkey = "AIzaSyAeBwhCv9Uo1NkgAV0jMtrbxKOK6Jix7fc";

final CameraPosition GooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

Position currentPosition;

FirebaseUser currentFirebaseUser;