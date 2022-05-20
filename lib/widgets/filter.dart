// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:memoire/theme/color.dart';

class Filter extends StatelessWidget {
  Filter({ Key? key, required this.data, this.selected = false, this.onTap}) : super(key: key);
  final data;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 10,bottom: 10),
         height: 40,
        decoration: BoxDecoration(
          color: selected ? primary : cardColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: .5,
              blurRadius: .5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Text(data["name"], maxLines: 1, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: selected ? Colors.white : darker),
        ),
      ),
    );
  }
}