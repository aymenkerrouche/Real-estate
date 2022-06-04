// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/models/offer.dart';
import 'package:memoire/screens/Client/Details.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/custom_textbox.dart';
import 'package:memoire/widgets/icon_box.dart';
import 'package:memoire/widgets/property_item.dart';

class SearchWilaya extends StatefulWidget {
  const SearchWilaya({Key? key, required this.data}) : super(key: key);
  final data;
  @override
  State<SearchWilaya> createState() => _SearchWilayaState();
}

class _SearchWilayaState extends State<SearchWilaya> {
  List<dynamic> lll = [];
  int userId = 0;
  bool _loading = true;
  late Offer offer;
  List offers = [];

  Future viewOffers() async {
    offers.clear();
    lll.clear();
    userId = await getUserId();

    ApiResponse response = await getOffersByData(widget.data);

    if (response.error == null) {
      setState(() {
        lll = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }

    lll.forEach((element) {
      offer = Offer.fromJson(element);
      offers.add(offer);
    });
  }

  @override
  void initState() {
    viewOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return viewOffers();
      },
      child: Scaffold(
          backgroundColor: background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: appBarColor,
                  pinned: false,
                  floating: true,
                  snap: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: getAppBar(),
                      ),
                    ),
                  )),
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
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
            width: size.width * 0.1,
            height: 50,
            child: Image.asset(
              "assets/applogo.png",
              fit: BoxFit.contain,
            )),
        SizedBox(
          width: 10,
        ),
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
          radius: 10,
          pad: 7,
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              color: red,
            ),
          ),
          child: SvgPicture.asset(
            'assets/icons/filter.svg',
            color: primary,
          ),
        )
      ],
    );
  }

  buildBody() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.04),
      child: Column(children: [
        listOffer(),
      ]),
    );
  }

  listOffer() {
    List<Widget> lists = List.generate(
        offers.length,
        (index) => PropertyItem(
              data: offers[index],
              height: 140.0,
              marg: 30.0,
              ontap: () {
                offer = offers[index];
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
                offer = offers[index];
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
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: lists),
    );
  }

  // Offer like dislik
  void offerLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);
    viewOffers();
    if (response.error == null) {
    } else if (response.error == unauthorized) {
      print(unauthorized);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
