// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, must_be_immutable, avoid_print, void_checks

import 'package:flutter/material.dart';
import 'package:memoire/theme/color.dart';

import 'custom_image.dart';




class RecommendItem extends StatefulWidget {
  RecommendItem({ Key? key, required this.data, this.onTap,this.width= 220,this.height=130,this.icon = Icons.place_outlined, this.onDoubleTap, }) : super(key: key);
  final data;
  final GestureTapCallback? onTap;
  double width;
  double height;
  IconData? icon;
  final GestureTapCallback?onDoubleTap;
  @override
  State<RecommendItem> createState() => _RecommendItemState();
}

class _RecommendItemState extends State<RecommendItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: widget.width, height: widget.height,
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              CustomImage(widget.data["image"], radius: 20, width: double.infinity, height: double.infinity,),
              Container(
                width: double.infinity, height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.white.withOpacity(.01),
                    ]
                  )
                ),
              ),
              Positioned(
                bottom: 12, left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.icon, color: Colors.white, size: 15,),
                        SizedBox(width: 5,),
                        Text(widget.data["name"], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
    );
  }
}

class MonthOption extends StatelessWidget {
  const MonthOption(
    this.title, {
    Key? key,
    required this.img,
    required this.onTap,
    required this.selected, type,
  }) : super(key: key);

  final String title;
  final String img;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        child: Ink.image(
          fit: BoxFit.cover,
          image: NetworkImage(img),
          child: InkWell(
            onTap: onTap,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? mainColor : Colors.transparent,
                      width: selected ? 5 : 0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected
                          ? mainColor
                          : Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}