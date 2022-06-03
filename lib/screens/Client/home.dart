// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/models/offer.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/category_item.dart';
import 'package:memoire/widgets/custom_textbox.dart';
import 'package:memoire/widgets/icon_box.dart';
import 'package:memoire/widgets/property_item.dart';
import 'package:memoire/widgets/recent_item.dart';
import 'package:memoire/widgets/recommend_item.dart';
import 'Details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _postList = [];
  bool _loading = true;
  late Offer offer;
  List popularoffers = [];

  Future<void> popularOffers() async {
    ApiResponse response = await getPopular();
    popularoffers.clear();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    popularoffers.clear();
    for (int i = 0; i < _postList.length; i++) {
      offer = Offer.fromJson(_postList[i]);
      popularoffers.add(offer);
    }
  }

  @override
  void initState() {
    popularOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primary,
      onRefresh: () {
        return popularOffers();
      },
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
              color: primary,
            ))
          : Scaffold(
              backgroundColor: appBgColor,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: appBarColor,
                    pinned: true,
                    snap: true,
                    floating: true,
                    title: getAppBar(),
                    collapsedHeight: 65,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => buildBody(),
                      childCount: 1,
                    ),
                  )
                ],
              )),
    );
  }

  Widget getAppBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Real Estate",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  )),
              SizedBox(
                height: 2,
              ),
              Text(
                "Agency",
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Image.asset(
            "assets/logo.png",
            width: 90,
            height: 55,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  buildBody() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.02,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.039, right: size.width * 0.039),
            child: Row(
              children: [
                Expanded(
                    child: CustomTextBox(
                  hint: "Search",
                  prefix: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: inActiveColor,
                    fit: BoxFit.scaleDown,
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                IconBox(
                    bgColor: primary,
                    radius: 10,
                    pad: 7,
                    onTap: () {
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      'assets/icons/filter.svg',
                      color: cardColor,
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, top: size.height * 0.03),
            child: listCategories(),
          ),
          SizedBox(height: size.height * 0.015),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, size.height * 0.013),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Popular",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    )),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          listPopulars(),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, size.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wilaya",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          listWilaya(),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, size.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "For you",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: darker),
                ),
              ],
            ),
          ),
          listRecent(),
        ]),
      ),
    );
  }

  listPopulars() {
    return CarouselSlider(
        options: CarouselOptions(
          height: 240,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .8,
        ),
        items: List.generate(
            populars.length,
            (index) => PropertyItem(
                  data: popularoffers[index],
                  ontap: () {
                    offer = popularoffers[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          id: offer.id!,
                        ),
                      ),
                    );
                  },
                  onTap: () {
                    offer = popularoffers[index];
                    offerLikeDislike(offer.id!);
                    switch (offer.selfLiked) {
                      case true:
                        offer.selfLiked = false;
                        break;
                      case false:
                        offer.selfLiked = true;
                        break;
                    }
                  },
                )));
  }

  listWilaya() {
    List<Widget> lists = List.generate(
        wilaya.length,
        (index) => RecommendItem(
              data: wilaya[index],
              onTap: () {},
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 0, left: 15),
      child: Row(children: lists),
    );
  }

  listRecent() {
    List<Widget> lists = List.generate(
        recents.length, (index) => RecentItem(data: recents[index]));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  int selectedCategory = 0;
  listCategories() {
    List<Widget> lists = List.generate(
        categories.length,
        (index) => CategoryItem(
              data: categories[index],
              selected: index == selectedCategory,
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
            ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  // Offer like dislik
  void offerLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);
    if (response.error == null) {
      popularOffers();
    } else if (response.error == unauthorized) {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
