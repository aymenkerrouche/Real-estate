// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String titre;
  const Background({
    Key? key,
    required this.child, required this.titre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double tol = size.height / 4;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: tol / 1.2,
            width: size.width,
            child: Text(
              titre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30,
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
              height: size.height / 2.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/back2.png",
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
