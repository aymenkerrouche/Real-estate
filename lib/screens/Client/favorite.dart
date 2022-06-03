// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offer.dart';
import 'package:memoire/Services/user.dart';
import 'package:memoire/screens/Client/Details.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/property_item.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> lll = [];
  int userId = 0;
  bool _loading = true;
  late Favorite offer;
  List offers = [];

  Future viewOffers() async {
    offers.clear();
    lll.clear();
    userId = await getUserId();

    ApiResponse response = await getFavorites();

    if (response.error == null) {
      setState(() {
        lll = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }

    lll.forEach((element) {
      offer = Favorite.fromJson(element);
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
          backgroundColor: appBarColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: appBarColor,
                pinned: true,
                snap: true,
                floating: true,
                title: getAppBar(),
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
          Expanded(
              child: Text("Favorites",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ))),
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
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02, horizontal: size.width * 0.04),
        child: listFavorite(),
      ),
    );
  }

  listFavorite() {
    List<Widget> lists = List.generate(
        offers.length,
        (index) => PropertyItem(
              data: offers[index],
              height: 140.0,
              marg: 30.0,
              onTap: () {
                offer = offers[index];
                Dislike(offer.id!);
              },
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
            ));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: lists),
    );
  }

  // Offer like dislik
  void Dislike(int id) async {
    ApiResponse response = await UnlikeOffer(id);
    if (response.error == null) {
      viewOffers();
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(unauthorized),
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
