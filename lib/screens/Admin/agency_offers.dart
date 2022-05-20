// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memoire/screens/Admin/add_offer.dart';
import 'package:memoire/screens/Admin/update_offer.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/property_item.dart';

import '../../Services/Api.dart';
import '../../Services/offer.dart';
import '../Client/Details.dart';

class AgencyOffers extends StatefulWidget {
  const AgencyOffers({Key? key}) : super(key: key);

  @override
  State<AgencyOffers> createState() => _AgencyOffersState();
}

class _AgencyOffersState extends State<AgencyOffers> {
  bool _loading = true;
  late Favorite offer;
  List offers = [];
  List offerList = [];
  bool anyOffer = true;

  Future<void> fetchOffers() async {
    ApiResponse response = await getAgencyOffers();
    offers.clear();
    if (response.error == null) {
      setState(() {
        offerList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(unauthorized),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
    offerList.forEach((element) {
      offer = Favorite.fromJson(element);
      offers.add(offer);
    });
    if (offers.isEmpty) {
      anyOffer = false;
    }
  }

  @override
  void initState() {
    fetchOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return fetchOffers();
      },
      child: Scaffold(
        backgroundColor: appBarColor,
        body: SafeArea(
          child: CustomScrollView(
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            child: Icon(
              Icons.add_rounded,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLogement(),
                ),
              );
            }),
      ),
    );
  }

  Widget getAppBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: primary,
              size: 25,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              "Your offers",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
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
    return anyOffer
        ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02, horizontal: size.width * 0.04),
              child: listAgencyOffers(),
            ),
          )
        : Container(
            width: size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/404.png"),
                Text(
                  "There are no offers",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
  }

  listAgencyOffers() {
    List<Widget> lists = List.generate(
        offers.length,
        (index) => EditOffer(
              data: offers[index],
              height: 140.0,
              marg: 30.0,
              onTap: () {
                offer = offers[index];
                options();
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

  Future<dynamic> options() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.grey.shade200,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 3),
            width: size.width * 0.1,
            height: 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: mainColor),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: primary,
            ),
            title: Text('Edit', style: TextStyle(color: primary)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateOffer(
                        id: offer.id!,
                      )),
            ),
          ),
          Divider(
            height: 15,
            color: cardColor,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outline_outlined,
              color: primary,
            ),
            title: Text('Delete'),
            onTap: () {
              delete();
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> delete() async {
    ApiResponse response = await deleteOfferPhotos(offer.id!);
    if (response.error == null) {
      ApiResponse response = await deleteOffer(offer.id!);
      if (response.error == null) {
        setState(() {
          fetchOffers();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data.toString())));
      } else if (response.error == unauthorized) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(unauthorized)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }
}
