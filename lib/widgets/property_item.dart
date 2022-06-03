// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';

import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/rate.dart';
import 'package:readmore/readmore.dart';

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
              '$urlImages/first/storage/app/${widget.data.image.toString()}',
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
                          width: size.width * 0.55,
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

class Photos extends StatefulWidget {
  Photos({Key? key, this.height = 300.0, this.marg = 20.0, this.data})
      : super(key: key);
  final height;
  final marg;
  final data;
  bool isShadow = true;
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
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
          boxShadow: [
            if (widget.isShadow)
              BoxShadow(
                color: shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
          ],
        ),
        child: GestureDetector(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (_) => imageDialog(
                    '$urlImages/first/storage/app/${widget.data}', context));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
            child: Image.network(
              "$urlImages/first/storage/app/${widget.data}",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

Widget imageDialog(path, context) {
  return Dialog(
    elevation: 80,
    child: Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 10,
            ),
          ]),
      child: Image.network(
        '$path',
        fit: BoxFit.cover,
      ),
    ),
  );
}

class EditOffer extends StatefulWidget {
  EditOffer(
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
              '$urlImages/first/storage/app/${widget.data.image.toString()}',
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

class Comments extends StatefulWidget {
  Comments({
    Key? key,
    required this.data,
    this.height = 150.0,
    this.marg = 20.0,
    this.child,
    this.onTap,
  }) : super(key: key);
  final data;
  final height;
  final marg;
  Widget? child;
  void Function()? onTap;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(right: 15),
      constraints: BoxConstraints(
        minHeight: size.height * 0.155,
      ),
      width: size.width * 0.9,
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        tileColor: primary.withOpacity(0.15),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '$urlImages/first/storage/app/${widget.data.user.image}',
              ),
            ),
          ],
        ),
        title: Text(
          "${widget.data.user.name}",
          style: TextStyle(color: primary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SmoothStarRating(
                  starCount: 5,
                  color: red,
                  allowHalfRating: true,
                  rating: 4.0,
                  size: 12.0,
                  borderColor: mainColor,
                  onRatingChanged: (double rating) {},
                ),
                SizedBox(width: 6.0),
                Text(
                  "February 14, 2020",
                  style: TextStyle(
                    fontSize: 12,
                    color: darker,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.0),
            ReadMoreText(
              "${widget.data.comment}",
              style: TextStyle(color: primary),
              trimLines: 2,
              colorClickableText: red,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Hide',
              moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darker,
                  overflow: TextOverflow.fade),
            ),
          ],
        ),
      ),
    );
  }
}
