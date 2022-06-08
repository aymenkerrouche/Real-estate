// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, unused_element, unrelated_type_equality_checks, avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/models/offer.dart';
import 'package:memoire/screens/Client/Details.dart';
import 'package:memoire/screens/map_page.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/custom_textbox.dart';
import 'package:memoire/widgets/filter.dart';
import 'package:memoire/widgets/filter_modal_bottom_sheet.dart';
import 'package:memoire/widgets/icon_box.dart';
import 'package:memoire/widgets/property_item.dart';
import 'package:memoire/widgets/recent_item.dart';

import 'liste_offers_map.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int userId = 0;
  List _postList = [];
  bool _loading = true;
  late Offer offer;
  List offers = [];
  List<dynamic> lll = [];
  var search;
  bool ifEmpty = false;

  Future<void> retrieveOffers() async {
    ApiResponse response = await getOffers();
    offers.clear();
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
    offers.clear();
    for (int i = 0; i < _postList.length; i++) {
      offer = Offer.fromJson(_postList[i]);
      offers.add(offer);
    }
    offers.isEmpty ? ifEmpty = true : ifEmpty = false;
  }

  Future viewOffers(data) async {
    offers.clear();
    lll.clear();
    ApiResponse response = await getOffersByData(data);
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
    offers.isEmpty ? ifEmpty = true : ifEmpty = false;
  }

  @override
  void initState() {
    retrieveOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          selectedCategory = -1;
          return retrieveOffers();
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
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
                      expandedHeight: size.width * 0.32,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: getAppBar(),
                              ),
                              Container(
                                child: listFilter(),
                              )
                            ],
                          ),
                        ),
                      )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ifEmpty
                          ? Container(
                              margin: EdgeInsets.only(top: size.height * 0.1),
                              width: size.width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset("assets/404.png"),
                                  Text(
                                    "There are no offers",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          : buildBody(),
                      childCount: 1,
                    ),
                  )
                ],
              )),
        ),
      ),
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
          onChanged: (value) {
            search = value;
          },
          onEditingComplete: () {
            viewOffers(search)
                .then((value) => FocusManager.instance.primaryFocus?.unfocus());
          },
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
          onTap: (){},
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

  int selectedCategory = -1;
  listFilter() {
    Size size = MediaQuery.of(context).size;
    List<Widget> lists = List.generate(
        filter.length,
        (index) => Filter(
              data: filter[index],
              selected: index == selectedCategory,
              onTap: () {
                setState(() {
                  selectedCategory = index;
                  switch (selectedCategory) {
                    case 0:
                      _settingModalBottomSheet(context);
                      break;
                    case 1:
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35))),
                          enableDrag: false,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Container(
                                height: size.height * 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35)),
                                  child: ListMap(),
                                ),
                              ));
                      break;
                    case 2:
                      viewOffers('Rent');
                      break;
                    case 3:
                      viewOffers('Sell');
                      break;
                    case 4:
                      viewOffers('Vacation');
                      break;
                    default:
                  }
                });
              },
            ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(top: 10, left: 15),
      child: Row(children: lists),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          var size = MediaQuery.of(context).size;
          return FilterPrice(
            onTap: GestureDetector(
              child: Container(
                width: 100,
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: Icon(
                    Icons.settings_backup_restore_outlined,
                    color: primary,
                  ),
                  onTap: () {
                    retrieveOffers();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                primary: Colors.black,
                padding: EdgeInsets.all(20),
              ),
              child: Text('Apply Filter', style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (FilterPrice.max == -1 && FilterPrice.min == -1) {
                  retrieveOffers();
                  Navigator.pop(context);
                } else {
                  priceOffers();
                  Navigator.pop(context);
                  FilterPrice.max = -1;
                  FilterPrice.min = -1;
                }
              },
            ),
          );
        });
  }

// Offer like dislik
  void offerLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);

    if (response.error == null) {
      retrieveOffers();
    } else if (response.error == unauthorized) {
      print(unauthorized);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<void> priceOffers() async {
    ApiResponse response =
        await getOffersByPrice(FilterPrice.min, FilterPrice.max);
    offers.clear();
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
    offers.clear();
    for (int i = 0; i < _postList.length; i++) {
      offer = Offer.fromJson(_postList[i]);
      offers.add(offer);
    }
  }

  Future<dynamic> logement() {
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
                Icons.camera_alt,
                color: primary,
              ),
              title: Text('Camera', style: TextStyle(color: primary)),
              onTap: () {}),
          Divider(
            height: 15,
            color: cardColor,
          ),
          ListTile(
              leading: Icon(
                Icons.image,
                color: primary,
              ),
              title: Text('Gallery', style: TextStyle(color: primary)),
              onTap: () {}),
          Divider(
            height: 15,
            color: cardColor,
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: primary,
            ),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
