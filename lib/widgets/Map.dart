// ignore_for_file: file_names, unused_field, prefer_final_fields, prefer_const_constructors, non_constant_identifier_names, unnecessary_string_interpolations, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Maps extends StatefulWidget {
  Maps({ Key? key, required this.loca, required this.location }) : super(key: key);
  LatLng loca;
  String location;
  
  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.07979228395479, 3.049194072788338),
    zoom: 4.9,
  );

  Set<Marker> _markers = {};



  void _setMarker(currentLocation) {
    Marker newMarker = Marker(
      markerId: MarkerId(currentLocation.toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: currentLocation,
      infoWindow: InfoWindow(
          title: "Address",
          snippet: "${widget.location}"),
    );
    _markers.add(newMarker);
  }


  void _animateCamera(currentLocation) async {
    _setMarker(currentLocation);
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: currentLocation,
      zoom: 16,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }



  @override
  void initState() {
    _animateCamera(widget.loca);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
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
              onCameraMove: (e) => widget.loca = e.target,
              markers: _markers,
            ),
          ]
    );
  }
}