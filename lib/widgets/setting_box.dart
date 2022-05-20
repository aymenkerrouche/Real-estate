// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/theme/color.dart';

class SettingBox extends StatelessWidget {
  SettingBox({ Key? key, required this.title, required this.icon, this.color = darker, this.wid=22.0, this.hei=22.0 }) : super(key: key);
  final title;
  final String icon;
  final Color color;
  final wid;
  final hei;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(icon, color: color, width: wid, height: hei,),
          SizedBox(height: 7,),
          Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }
}