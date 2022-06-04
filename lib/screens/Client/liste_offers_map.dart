// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_element, prefer_final_fields, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/models/offer_maps.dart';

import '../../Services/Api.dart';
import '../../Services/location_services.dart';
import 'Details.dart';

class ListMap extends StatefulWidget {
  const ListMap({Key? key}) : super(key: key);
  @override
  State<ListMap> createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  List listOffers = [];
  List<OfferMap> offers = [];
  late OfferMap offer;

  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.07979228395479, 3.049194072788338),
    zoom: 4.9,
  );

  Set<Marker> _markers = {};

  Future<void> getOfferMap() async {
    ApiResponse response = await getOffersOnMap();
    if (response.error == null) {
      List listOffers = response.data as List<dynamic>;
      for (var i = 0; i < listOffers.length; i++) {
        offer = OfferMap.fromJson(listOffers[i]);
        offer.adrs = LatLng(offer.latitude!, offer.longitude!);
        offers.add(offer);
        setState(() {
          _setMarker(offer.adrs, offer.id);
          print(offer.id);
        });
      }
    }
  }

  void _setMarker(curre, id) {
    Marker newMarker = Marker(
      markerId: MarkerId(curre.toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: curre,
      infoWindow: InfoWindow(
          title: "${offer.name}",
          snippet: "${offer.location}",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetails(
                  id: id,
                ),
              ),
            );
          }),
    );
    _markers.add(newMarker);
  }

  @override
  void initState() {
    getOfferMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          mapType: MapType.hybrid,
          onMapCreated: (controller) async {
            String style = await DefaultAssetBundle.of(context)
                .loadString('assets/map_style.json');
            controller.setMapStyle(style);
            _controller.complete(controller);
          },
          markers: _markers,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getMyLocation(),
        backgroundColor: Colors.black,
        elevation: 20,
        child: Icon(Icons.gps_fixed),
      ),
    );
  }

  Future<void> _getMyLocation() async {
    LocationData _myLocation = await LocationService().getLocation();
    _animateCamera(LatLng(_myLocation.latitude!, _myLocation.longitude!));
  }

  Future<void> _animateCamera(LatLng _location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: _location,
      zoom: 13,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
