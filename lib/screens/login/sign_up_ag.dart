// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, unnecessary_null_comparison, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_final_fields, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/models/user.dart';
import 'package:memoire/screens/map_page.dart';
import 'package:memoire/screens/root_app.dart';
import 'package:memoire/widgets/background_in.dart';
import 'package:memoire/widgets/input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/Api.dart';
import '../../theme/color.dart';
import '../../utils/data.dart';

class Agency extends StatefulWidget {
  const Agency({Key? key}) : super(key: key);

  @override
  State<Agency> createState() => _AgencyState();
}

class _AgencyState extends State<Agency> {
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemprary = File(image.path);
      setState(() => this.image = imageTemprary);
    } on PlatformException catch (e) {
      print('failed : $e');
    }
  }

  var phone;
  var location;
  var id;
  bool done = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double tol = size.height / 4;
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Background(
          titre: 'Sign up',
          child: SingleChildScrollView(
            child: Container(
              height: size.height * 0.7,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: size.height * 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //titre
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back_rounded, size: 30.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        //titre
                        Expanded(
                          child: Text(
                            'Agency Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: size.height / 25,
                              color: const Color(0xff252427),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //input
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Textfield(
                          'Phone',
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Textfield(
                          'Location',
                          child: TextFormField(
                              onTap: () => showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) => MapPage()),
                              readOnly: true,
                              onChanged: (value) {
                                setState(() {
                                  location = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: MapScreen.adrs,
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: size.height / 22,
                                child: Text(
                                  'Choose File',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(size.width, size.height / 15),
                                  primary: Colors.grey[350]!.withOpacity(0.6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: image == null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Picture path',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7)),
                                            ),
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.black,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          image!.path,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.grey.shade200,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          width: size.width * 0.1,
                                          height: 4,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: mainColor),
                                        ),
                                        ListTile(
                                            leading: Icon(
                                              Icons.camera_alt,
                                              color: primary,
                                            ),
                                            title: Text('Camera',
                                                style:
                                                    TextStyle(color: primary)),
                                            onTap: () =>
                                                pickImage(ImageSource.camera)),
                                        Divider(
                                          height: 15,
                                          color: cardColor,
                                        ),
                                        ListTile(
                                            leading: Icon(
                                              Icons.image,
                                              color: primary,
                                            ),
                                            title: Text('Gallery',
                                                style:
                                                    TextStyle(color: primary)),
                                            onTap: () =>
                                                pickImage(ImageSource.gallery)),
                                        Divider(
                                          height: 15,
                                          color: cardColor,
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.delete,
                                            color: primary,
                                          ),
                                          title: Text('Delete'),
                                          onTap: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //sign up button
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: size.width / 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width, size.height / 15),
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                            ),
                            onPressed: () {
                              _registerUser();
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: size.width / 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width, size.height / 15),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: BorderSide(
                                      width: 1.5, color: Colors.black)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
  }

  void _registerUser() async {
    ApiResponse response = await register(
        profile["name"]!, profile["email"]!, pswrd, 0.toString());
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
      user = response.data as User;
      profile["name"] = user!.name!;
      profile["email"] = user!.email!;
      id = user!.id;
      _agencyResiter();
    } else {
      print(response.error);
    }
  }

  void _agencyResiter() async {
    var response = await registerImage(image!.path, id, MapScreen.adrs,
        MapScreen.loc.latitude, MapScreen.loc.longitude, phone);
    if (response.statusCode == 200) {
      done = true;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RootApp(usertype: 0)),
          (route) => false);
    } else {
      print(response.statusCode);
    }
  }
}
