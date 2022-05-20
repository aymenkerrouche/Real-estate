// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/user.dart';
import 'package:memoire/screens/map_page.dart';
import 'package:memoire/screens/root_app.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/input.dart';

import '../../Services/offer.dart';

class UpdateOffer extends StatefulWidget {
  const UpdateOffer({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<UpdateOffer> createState() => _UpdateOfferState();
}

class _UpdateOfferState extends State<UpdateOffer> {
  int agency_id = 1;
  LatLng location = const LatLng(0, 0);
  String name = '';
  int price = 0;
  String description = '';
  String trading_type = '';
  int rooms = 0;
  int bed = 0;
  int visitors = 0;
  int bathroom = 0;
  var trad_type = [];
  int userId = 0;
  Offer? offer;
  bool _loading = true;
  double? longitude;
  double? latitude;

  var date;
  var dateStart = DateTime.now().toString();
  var dateEnd = DateTime.now().toString();

  List<dynamic> info = [];

  Future<void> detais() async {
    userId = await getUserId();
    ApiResponse response = await getDetailsOffer(widget.id);
    if (response.error == null) {
      setState(() {
        info = response.data as List<dynamic>;
        for (int i = 0; i < info.length; i++) {
          offer = Offer.fromJson(info[i]);
        }
        _loading = false;
        latitude = offer!.latitude!;
        longitude = offer!.longitude!;
        location = LatLng(latitude!, longitude!);
        MapScreen.loc = location;
        CustomStepper.rooms = offer!.rooms!;
        CustomStepper.bed = offer!.bed!;
        CustomStepper.bathroom = offer!.bathroom!;
        CustomStepper.visitors = offer!.visitors!;
        LogementType.logement_type = offer!.logement_type!;
        Daye.start = offer!.date_start;
        Daye.end = offer!.date_end;
      });
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(unauthorized),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    detais();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: _loading
              ? Center(child: CircularProgressIndicator())
              : CustomScrollView(
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
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
              icon: const Icon(
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
              child: const Divider(
                color: labelColor,
              ),
            ),

            // titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'TITLE',
                child: TextFormField(
                  cursorColor: mainColor,
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    hintText: '${offer!.name}',
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Description',
                child: TextFormField(
                  cursorColor: mainColor,
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(
                    hintText: '${offer!.description}',
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Location',
                child: TextFormField(
                    onChanged: (value) {
                      location = value as LatLng;
                    },
                    decoration: InputDecoration(
                      hintText: '${offer!.location}',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Textfield(
                'Price',
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: mainColor,
                  onChanged: (value) {
                    price = int.parse(value);
                  },
                  decoration: InputDecoration(
                    hintText: '${offer!.price}',
                    border: InputBorder.none,
                    suffixIcon: Container(
                      height: 24,
                      width: 24,
                      child: const Image(image: AssetImage("assets/dinar.png")),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: const Divider(
                color: labelColor,
              ),
            ),

            //Date
            Daye(),

            //plus infos
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: const Divider(
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
              child: const Divider(
                color: labelColor,
              ),
            ),

            //trading type
            Tgl(),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: const Divider(
                color: labelColor,
              ),
            ),

            //Select Images
            Images(),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.03),
              child: const Divider(
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
                      side: const BorderSide(color: primary),
                    ),
                    onPressed: () {
                      CustomStepper.visitors = 0;
                      CustomStepper.bathroom = 0;
                      CustomStepper.bed = 0;
                      CustomStepper.rooms = 0;
                      MapScreen.loc = const LatLng(0, 0);
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
                            return const RootApp(
                              usertype: 0,
                            );
                          },
                        ),
                        (roote) => false,
                      );
                    },
                    child: const Text(
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
                      MapScreen.loc = const LatLng(0, 0);
                      MapScreen.adrs = null;
                      Daye.start = DateTime.now().toString();
                      Daye.end = DateTime.now().toString();
                      Tgl.vacation = false;
                      Tgl.Rent = false;
                      Tgl.Sell = false;
                      LogementType.logement_type = '';
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color(0xffffffff),
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

    var data = Map<dynamic, dynamic>();
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
    trad_type.clear();
    var response = await updateData(data);
    if (response.statusCode == 200) {
      ApiResponse offer_id = await getOfferID();
      if (offer_id.error == null) {
        offerImage(Images.listPath, offer_id.data);
        showMsg('Offer Created Successfully');
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
      MapScreen.adrs = null;
      data.clear();
    } else {
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
