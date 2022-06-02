// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace, avoid_print, prefer_typing_uninitialized_variables, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';


import 'dart:async';
import 'package:memoire/Services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';


class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapScreen(),
    );
  }
}



class MapScreen extends StatefulWidget {
  static LatLng loc = LatLng(37.07979228395479, 3.049194072788338) ;
  static var adrs;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.07979228395479, 3.049194072788338),
    zoom: 4.9,
  );

  LatLng currentLocation = _initialCameraPosition.target;

  Set<Marker> _markers = {};

  String Address = 'Your Adrreess' ;
  String Country = '';
  String Name = '';
  String City = '';
  String Street = '';
  String Thoroughfare = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.hybrid,
            onMapCreated: (controller) async {
              String style = await DefaultAssetBundle.of(context)
                  .loadString('assets/map_style.json');
              controller.setMapStyle(style);
              _controller.complete(controller);
            },
            onCameraMove: (e) => currentLocation = e.target,
            markers: _markers,
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/location.png'),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [ 
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30),),), 
              context: context,
              builder: (context) => Container(
                height: 200,
                child: Center(child: Text(' Country : $Country \n City :  $City\n Street :  $Street\n ')),
              ),
            ),
            child: Icon(Icons.info_outlined,),
          ), 
          SizedBox(height: 10,), 
          FloatingActionButton(
            onPressed: () => _setMarker(currentLocation),
            backgroundColor: Colors.black,
            child: Icon(Icons.add_location_alt_outlined),
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            onPressed: () => _getMyLocation(),
            backgroundColor: Colors.black,
            child: Icon(Icons.gps_fixed),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text(
            "lat: ${currentLocation.latitude}, long: ${currentLocation.longitude}"),
      ),
    );
  }

  

  void _setMarker(LatLng _location) {
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: _location,
      infoWindow: InfoWindow(
          title: Address,
          snippet: "$City, $Country"),
    );
    _markers.add(newMarker);
    setState(() {
      MapScreen.loc = _location;
      GetAddressFromLatLong(_location);
    });
  }
 
  Future<void> _getMyLocation() async {
    LocationData _myLocation = await LocationService().getLocation();
    _animateCamera(LatLng(_myLocation.latitude!, _myLocation.longitude!));
    GetAddressFromLatLong(_myLocation);
  }

  Future<void> _animateCamera(LatLng _location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: _location,
      zoom: 16,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    MapScreen.loc = _location; 
  }

  Future<void> GetAddressFromLatLong(currentLocation)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    setState(()  {
      Street = place.street!;
      Country = place.country!;
      City = place.administrativeArea!;
      Name = place.name!;
      MapScreen.loc = currentLocation;
      MapScreen.adrs = Street+' '+City+', '+Country ;
    });
  }

  
}