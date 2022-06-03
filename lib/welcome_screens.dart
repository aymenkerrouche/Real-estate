// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memoire/screens/login/landing.dart';
import 'package:memoire/theme/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                isFirst = (index == 0);
              });
            },
            children: [
              Container(
                color: white,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.1),
                      height: size.height * 0.7,
                      width: size.width,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/welcome/Buying.svg',
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.5),
                      child: Text(
                        'Welcome to Real Estate Property Management.\n App that operates an online marketplace for lodging ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        strutStyle: StrutStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: white.withOpacity(0.15),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.1),
                      height: size.height * 0.7,
                      width: size.width,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/welcome/search_house.svg',
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.5),
                      child: Text(
                        'Primarily homestays for vacation rentals,\n and tourism activities.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        strutStyle: StrutStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: white.withOpacity(0.1),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.1),
                      height: size.height * 0.7,
                      width: size.width,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/welcome/world.svg',
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.5),
                      child: Text(
                        "SMALL world !\n Now you can book anywhere at any time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        strutStyle: StrutStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                isFirst
                    ? GestureDetector(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => XDLanding(),
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeOutQuad);
                        },
                      ),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),

                onLastPage
                    ? GestureDetector(
                        child: Text(
                          'Start',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => XDLanding(),
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeOutQuad);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
