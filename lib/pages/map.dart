import 'dart:async';
import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MapPage extends StatefulWidget {
  String userDoc;
  MapPage({this.userDoc});
  @override
  State createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Set<Marker> allMarkers = Set();

  Location _locationService = Location();
  bool _permission = false;

  String inputaddr = '';

  addToList() async {
    final query = inputaddr;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    Firestore.instance.collection('mechanic').add({
      'coods':
          new GeoPoint(first.coordinates.latitude, first.coordinates.longitude),
      'address': first.featureName
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  initState() {
    super.initState();

    initLocation();
    addMarkers();
  }

  initLocation() async {
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          final location = await _locationService.getLocation();

          final _currentCameraPosition = CameraPosition(
              target: LatLng(location.latitude, location.longitude), zoom: 13);

          _controller.animateCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));
          var mapicon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
              "assets/customer.png");
          setState(() {
            allMarkers.add(
              Marker(
                icon: mapicon,
                markerId: MarkerId("my-location"),
                position: LatLng(location.latitude, location.longitude),
              ),
            );
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initLocation();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void addMarkers() {
    Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: "mechanic")
        .getDocuments()
        .then((snapshots) {
      var machanicLocationIcon = snapshots.documents
          .toList()
          .map((DocumentSnapshot documentSnapshot) async => Marker(
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
                  "assets/mechanic.png"),
              markerId: MarkerId(documentSnapshot.documentID),
              position: LatLng(
                  (documentSnapshot.data['coods'] as GeoPoint).latitude,
                  (documentSnapshot.data['coods'] as GeoPoint).longitude),
             ))
          .toList();
      Future.wait(machanicLocationIcon).then((lsit) {
        print(lsit.length);
        setState(() {
          allMarkers.addAll(lsit);
        });
      });
    });
  }

  GlobalKey<ScaffoldState> _sacaffoldkey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(widget.userDoc);
    return new Scaffold(
      key: _sacaffoldkey,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          "Easy Fix",
          style: TextStyle(color: Colors.orange),
        ),
        leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              _sacaffoldkey.currentState.openDrawer();
            }),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: _kGooglePlex,
        compassEnabled: true,
        mapToolbarEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        rotateGesturesEnabled: true,
        trafficEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: allMarkers,
      ),
     
    );
  }
}