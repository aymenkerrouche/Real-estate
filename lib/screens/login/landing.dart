// ignore_for_file: prefer_const_constructors, duplicate_ignore, unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/screens/login/login.dart';
import 'package:memoire/theme/color.dart';
import 'sign_up.dart';

class XDLanding extends StatelessWidget {
  const XDLanding({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double tol = size.height / 4;
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.175,
            width: size.width,
            child: Text(
              'REAL ESTATE AGENCY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: size.height / 30,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: -2,
            right: -2,
            child: Container(
              width: double.infinity,
              height: size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/back.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.3,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 7,
                top: 7,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: size.width,
                      child: Lottie.asset('assets/log/74247-blue-house.json',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Let start your Adventure',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff252427),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      height: 50,
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(220, 1, 1, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                        ),
                        onPressed: () {
                          logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
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
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(
                            width: 2.0,
                            color: Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                        ),
                        onPressed: () {
                          logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
