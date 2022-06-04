// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:memoire/theme/color.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem(
      {Key? key, required this.data, this.selected = false, this.onTap})
      : super(key: key);
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
        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
        margin: EdgeInsets.only(right: 10),
        constraints: BoxConstraints(minWidth: 80, minHeight: 85),
        height: 80,
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
        child: Column(
          children: [
            Icon(data["icon"],
                size: 25, color: selected ? Colors.white : Colors.black),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Text(
                data["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: selected ? Colors.white : darker),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Equip extends StatefulWidget {
  const Equip({Key? key, required this.data, this.offer}) : super(key: key);
  final data;
  final offer;
  @override
  State<Equip> createState() => _EquipState();
}

class _EquipState extends State<Equip> {
  var a;
  @override
  Widget build(BuildContext context) {
    a = widget.data["name"];

    if (widget.data["name"] == "Bed") {
      a = widget.offer.bed.toString();
    }
    if (widget.data["name"] == "Bath") {
      a = widget.offer.bathroom.toString();
    }
    if (widget.data["name"] == "Room") {
      a = widget.offer.rooms.toString();
    }
    if (widget.data["name"] == "Visitors") {
      a = widget.offer.visitors.toString();
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.09,
      margin: EdgeInsets.only(right: size.width * 0.09),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(widget.data["icon"], size: 25, color: Colors.black),
          SizedBox(
            height: 5,
          ),
          Text(
            a == widget.data["name"] ? "$a" : "$a ${widget.data["name"]}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: darker),
          ),
        ],
      ),
    );
  }
}
