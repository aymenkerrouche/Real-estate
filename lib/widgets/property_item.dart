// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, must_be_immutable

import 'package:flutter/material.dart';

import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/data.dart';

import 'custom_image.dart';
import 'icon_box.dart';

class PropertyItem extends StatefulWidget {
  PropertyItem(
      {Key? key,
      required this.data,
      this.height = 150.0,
      this.marg = 20.0,
      this.child,
      this.onTap,
      this.ontap})
      : super(key: key);
  final data;
  final height;
  final marg;
  Widget? child;
  void Function()? onTap;
  void Function()? ontap;
  @override
  State<PropertyItem> createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: double.infinity,
        height: 210,
        margin: EdgeInsets.fromLTRB(0, 0, 0, widget.marg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: .5,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              right: 15,
              child: Text(
                widget.data.price.toString(),
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
            ),
            CustomImage(
              widget.data.image.toString(),
              radius: 25,
              width: double.infinity,
              height: widget.height,
            ),
            Positioned(
                    right: 20,
                    top: 140.0 - 20,
                    child: IconBox(
                      bgColor: cardColor,
                      pad: 3,
                      onTap: widget.onTap,
                      child: Icon(
                        widget.data.selfLiked == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: actionColor,
                        size: 30,
                      ),
                    )),
            Positioned(
                left: 15,
                top: widget.height + 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          color: darker,
                          size: 13,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            widget.data.location.toString(),
                            style: TextStyle(fontSize: 13, color: darker),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class Popular extends StatefulWidget {
  const Popular(
      {Key? key, required this.data, this.height = 150.0, this.marg = 20.0})
      : super(key: key);
  final data;
  final height;
  final marg;
  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      margin: EdgeInsets.fromLTRB(0, 0, 0, widget.marg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            spreadRadius: .5,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 15,
            right: 15,
            child: Text(
              widget.data["price"],
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1),
            ),
          ),
          CustomImage(
            widget.data["image"],
            radius: 25,
            width: double.infinity,
            height: widget.height,
          ),
          Positioned(
              right: 20,
              top: widget.height - 20,
              child: IconBox(
                  child: Icon(
                    widget.data["is_favorited"]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: actionColor,
                    size: 30,
                  ),
                  bgColor: cardColor,
                  pad: 3,
                  onTap: () {
                    switch (widget.data["is_favorited"]) {
                      case true:
                        widget.data["is_favorited"] = false;
                        break;
                      default:
                        widget.data["is_favorited"] = true;
                    }
                    setState(() {});
                  })),
          Positioned(
              left: 15,
              top: widget.height + 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["name"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: darker,
                        size: 13,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.data["location"],
                        style: TextStyle(fontSize: 13, color: darker),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class Photos extends StatefulWidget {
  const Photos({Key? key, this.height = 150.0, this.marg = 20.0, this.data})
      : super(key: key);
  final height;
  final marg;
  final data;
  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      margin: EdgeInsets.only(bottom: widget.marg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            spreadRadius: .5,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: CustomImage(
        widget.data["image"],
        radius: 25,
        width: double.infinity,
        height: widget.height,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
      ),
    );
  }
}


class EditOffer extends StatefulWidget {
  EditOffer({Key? key,
      required this.data,
      this.height = 150.0,
      this.marg = 20.0,
      this.child,
      this.onTap,
      this.ontap}) : super(key: key);
      final data;
  final height;
  final marg;
  Widget? child;
  void Function()? onTap;
  void Function()? ontap;

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        width: double.infinity,
        height: 210,
        margin: EdgeInsets.fromLTRB(0, 0, 0, widget.marg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.1),
              spreadRadius: .5,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              right: 15,
              child: Text(
                widget.data.price.toString(),
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
            ),
            CustomImage(
              widget.data.image.toString(),
              radius: 25,
              width: double.infinity,
              height: widget.height,
            ),
            Positioned(
                    right: 20,
                    top: 120,
                    child: IconBox(
                      bgColor: cardColor,
                      pad: 3,
                      onTap: widget.onTap,
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: primary,
                        size: 30,
                      ),
                    )),
            Positioned(
                left: 15,
                top: widget.height + 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          color: darker,
                          size: 13,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        SizedBox(
                          width: size.width * 0.6,
                          child: Text(
                            widget.data.location.toString(),
                            style: TextStyle(fontSize: 13, color: darker),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}