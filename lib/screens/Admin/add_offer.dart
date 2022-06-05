// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, constant_identifier_names, unnecessary_const, non_constant_identifier_names, sized_box_for_whitespace, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable, unnecessary_new, prefer_collection_literals, unused_element, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/screens/map_page.dart';
import 'package:memoire/screens/root_app.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/category_item.dart';
import 'package:memoire/widgets/custom_image.dart';
import 'package:memoire/widgets/custom_textbox.dart';
import 'package:memoire/widgets/input.dart';
import 'package:memoire/widgets/property_item.dart';
import 'package:memoire/widgets/recent_item.dart';
import 'package:memoire/widgets/recommend_item.dart';
import 'package:intl/intl.dart';

class AddLogement extends StatefulWidget {
  const AddLogement({Key? key}) : super(key: key);
  @override
  State<AddLogement> createState() => _AddLogementState();
}

class _AddLogementState extends State<AddLogement> {
  int agency_id = 1;
  LatLng location = LatLng(0, 0);
  String name = '';
  int price = 0;
  String description = '';
  String trading_type = '';
  int rooms = 0;
  int bed = 0;
  int visitors = 0;
  int bathroom = 0;
  var trad_type = [];

  var date;
  var dateStart = DateTime.now().toString();
  var dateEnd = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   floating: true,
          //   pinned: true,
          //   snap: false,
          //   automaticallyImplyLeading: false,
          //   backgroundColor: primary,
          //   title: getAppBar(),
          //   collapsedHeight: size.height * 0.08,
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildBody(),
              childCount: 1,
            ),
          )
        ],
      )),
    );
  }

  Widget getAppBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Logement type",
                  style: TextStyle(
                    color: appBarColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  )),
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.close,
                size: 24,
              ))
        ],
      ),
    );
  }

  buildBody() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //logoment type
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: LogementType(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.02),
              child: Divider(
                color: labelColor,
              ),
            ),

            // titre
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'TITLE',
                child: TextFormField(
                  cursorColor: mainColor,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Logement name',
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.home,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Description',
                child: TextFormField(
                  cursorColor: mainColor,
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Logement description',
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.description,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            //location
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Location',
                child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Constantine, Algeria',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        onPressed: () => showModalBottomSheet(
                            enableDrag: false,
                            context: context,
                            builder: (context) => MapPage()),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            // Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Price',
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: mainColor,
                  onChanged: (value) {
                    price = int.parse(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Logement price',
                    border: InputBorder.none,
                    suffixIcon: Container(
                      height: 24,
                      width: 24,
                      child: Image(image: AssetImage("assets/dinar.png")),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: Divider(
                color: labelColor,
              ),
            ),

            //Date
            Daye(),

            //plus infos
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: Divider(
                color: labelColor,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomStepper(
                  lowerLimit: 0,
                  upperLimit: 100,
                  stepValue: 1,
                  iconSize: 20,
                  value: rooms,
                  titre: 'Rooms',
                ),
                CustomStepper(
                  lowerLimit: 0,
                  upperLimit: 100,
                  stepValue: 1,
                  iconSize: 20,
                  value: bed,
                  titre: 'bed',
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomStepper(
                  lowerLimit: 0,
                  upperLimit: 100,
                  stepValue: 1,
                  iconSize: 20,
                  value: bathroom,
                  titre: 'bathroom',
                ),
                CustomStepper(
                  lowerLimit: 0,
                  upperLimit: 100,
                  stepValue: 1,
                  iconSize: 20,
                  value: visitors,
                  titre: 'visitors',
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: Divider(
                color: labelColor,
              ),
            ),

            //trading type
            Tgl(),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: Divider(
                color: labelColor,
              ),
            ),

            //Select Images
            Images(),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: Divider(
                color: labelColor,
              ),
            ),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Cancel
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.4, size.height * 0.06),
                      primary: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: primary),
                    ),
                    onPressed: () {
                      CustomStepper.visitors = 0;
                      CustomStepper.bathroom = 0;
                      CustomStepper.bed = 0;
                      CustomStepper.rooms = 0;
                      MapScreen.loc = LatLng(0, 0);
                      MapScreen.adrs = null;
                      Daye.start = DateTime.now().toString();
                      Daye.end = DateTime.now().toString();
                      Tgl.vacation = false;
                      Tgl.Rent = false;
                      Tgl.Sell = false;
                      Images.listImage.clear();
                      LogementType.logement_type = '';
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return RootApp(
                              usertype: 0,
                            );
                          },
                        ),
                        (roote) => false,
                      );
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                //Add
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.03),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.4, size.height * 0.06),
                      primary: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      dateStart = DateFormat('yyyy-MM-dd').format(Daye.start);
                      dateEnd = DateFormat('yyyy-MM-dd').format(Daye.end);
                      location = MapScreen.loc;
                      rooms = CustomStepper.rooms;
                      bed = CustomStepper.bed;
                      bathroom = CustomStepper.bathroom;
                      visitors = CustomStepper.visitors;
                      trad_type.clear();
                      _submit();
                      CustomStepper.visitors = 0;
                      CustomStepper.bathroom = 0;
                      CustomStepper.bed = 0;
                      CustomStepper.rooms = 0;
                      MapScreen.loc = LatLng(0, 0);
                      MapScreen.adrs = null;
                      Daye.start = DateTime.now().toString();
                      Daye.end = DateTime.now().toString();
                      Tgl.vacation = false;
                      Tgl.Rent = false;
                      Tgl.Sell = false;
                      LogementType.logement_type = '';
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (Tgl.Rent == true) {
      trad_type.add('Rent ');
    }
    if (Tgl.Sell == true) {
      trad_type.add(' Sell ');
    }
    if (Tgl.vacation == true) {
      trad_type.add(' Vacation');
    }
    var data = new Map<dynamic, dynamic>();
    data['name'] = name;
    data["description"] = description;
    data['logement_type'] = LogementType.logement_type;
    data['trading_type'] = trad_type.toString();
    data['rooms'] = rooms;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data["bathroom"] = bathroom;
    data["bed"] = bed;
    data['price'] = price;
    data['visitors'] = visitors;
    data['latitude'] = location.latitude;
    data['longitude'] = location.longitude;
    data['location'] = MapScreen.adrs;

    var response = await Api().postData(data, '/offer');
    if (response.statusCode == 200) {
      ApiResponse offer_id = await getOfferID();
      if (offer_id.error == null) {
        postOfferImage(Images.listPath, offer_id.data);
        showMsg('Offer Created Successfully');
        Navigator.pushAndRemoveUntil( context,MaterialPageRoute(builder: (BuildContext context) {return RootApp(usertype: 0,);}, ),(roote) => false,);
      }
      MapScreen.adrs = null;
      data.clear();
      trad_type.clear();
    } 
    else {
      MapScreen.adrs = null;
      showMsg('Error ${response.statusCode}');
      print(response.statusCode);
      trad_type.clear();
      data.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return RootApp(
              usertype: 0,
            );
          },
        ),
        (roote) => false,
      );
    }
  }

  showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    ));
  }
}
