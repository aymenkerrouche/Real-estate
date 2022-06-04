// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, file_names, use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/commentController.dart';
import 'package:memoire/Services/offerController.dart';
import 'package:memoire/Services/userController.dart';
import 'package:memoire/models/comment.dart';
import 'package:memoire/models/offer.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/Map.dart';

import 'package:memoire/widgets/category_item.dart';
import 'package:memoire/widgets/icon_box.dart';
import 'package:memoire/widgets/property_item.dart';
import 'package:memoire/widgets/rate.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;
  int userId = 0;
  bool _loading = true;
  Offer? offer;
  List<dynamic> data = [];
  double? longitude;
  double? latitude;
  LatLng? lo;
  var phone;
  List _commentsList = [];
  List showComments = [];
  Comment? comment;
  String? newComment;
  List getimgs = [];
  List showImages = [];
  var img;

  Future<void> detais() async {
    data.clear();
    _commentsList.clear();
    showComments.clear();
    userId = await getUserId();
    ApiResponse response = await getDetailsOffer(widget.id);
    if (response.error == null) {
      setState(() {
        data = response.data as List<dynamic>;
        for (int i = 0; i < data.length; i++) {
          offer = Offer.fromJson(data[i]);
        }
        _loading = false;
        latitude = offer!.latitude!;
        longitude = offer!.longitude!;
        lo = LatLng(latitude!, longitude!);
        getNum();
        _getComments();
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
  }

  @override
  void initState() {
    detais().then((value) => _getImages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () {
        return detais().then((value) => _getImages());
      },
      child: Scaffold(
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                color: primary,
              ))
            : SafeArea(
                child: ListView(
                  children: <Widget>[
                    //photos & Favorite
                    Stack(
                      children: [
                        //photos
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          height: size.height * 0.35,
                          width: size.width,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                height: 300,
                                enlargeCenterPage: true,
                                disableCenter: true,
                                viewportFraction: 1,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 10),
                              ),
                              items: List.generate(
                                  showImages.length,
                                  (index) => Photos(
                                      data: showImages[index], marg: 10.0))),
                        ),

                        //Favorite
                        Positioned(
                            bottom: 11,
                            right: 15,
                            child: IconBox(
                              bgColor: cardColor.withOpacity(0.9),
                              pad: 3,
                              onTap: () {
                                handlePostLikeDislike(offer!.id!);
                                setState(() {
                                  switch (offer!.selfLiked) {
                                    case true:
                                      offer!.selfLiked = false;
                                      break;
                                    case false:
                                      offer!.selfLiked = true;
                                      break;
                                  }
                                });
                              },
                              child: Icon(
                                offer!.selfLiked == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: actionColor,
                                size: size.width * 0.09,
                              ),
                            )),
                      ],
                    ),

                    //body
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Titre , Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //titre
                              Container(
                                width: size.width * 0.65,
                                child: Text(
                                  "${offer!.name}",
                                  style: TextStyle(
                                    fontSize: size.width * 0.08,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),

                              //Price
                              Container(
                                width: size.width * 0.25,
                                child: Text(
                                  "${offer!.price} /year",
                                  style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green.shade600),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            "${offer!.logement_type}",
                            style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600),
                            textAlign: TextAlign.right,
                          ),

                          //Rating
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                            child: SmoothStarRating(
                              starCount: 5,
                              color: red,
                              allowHalfRating: true,
                              rating: 4.0,
                              size: 15.0,
                              borderColor: primary,
                              onRatingChanged: (double rating) {},
                            ),
                          ),

                          //Equipements
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.03),
                            child: listCategories(),
                          ),

                          //Description
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 15.0),
                          ReadMoreText(
                            "${offer!.description}",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            trimLines: 4,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Hide',
                            moreStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: darker),
                            lessStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: red),
                          ),
                          SizedBox(height: 25.0),

                          //Location
                          Text(
                            "Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                              ),
                              //address
                              Container(
                                width: size.width * 0.8,
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "${offer!.location}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          //Map
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(2),
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: primary)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  heightFactor: 0.3,
                                  widthFactor: 2.5,
                                  child: Maps(
                                    loca: lo!,
                                    location: offer!.location!,
                                  )),
                            ),
                          ),
                          SizedBox(height: 25.0),

                          //Comments
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Comments",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    openDialog();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/add.svg',
                                    color: primary,
                                    width: 28,
                                    height: 28,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 25.0),
                          listComments(),
                          SizedBox(height: 25.0),

                          //contacts
                          Text(
                            "Contacts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: size.width * 0.15,
                                width: size.width * 0.3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 15,
                                    primary: primary.withOpacity(0.9),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () async {
                                    final Uri tlpn = Uri(
                                      scheme: 'smsto',
                                      path: "0$phone",
                                    );
                                    await launchUrl(tlpn);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/send.svg',
                                        color: white,
                                      ),
                                      Text(
                                        'SMS',
                                        style: TextStyle(
                                            fontSize: size.width * 0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.width * 0.15,
                                width: size.width * 0.5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green.shade500,
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () async {
                                    final Uri tlpn = Uri(
                                      scheme: 'tel',
                                      path: "0$phone",
                                    );
                                    await launchUrl(tlpn);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.phone_rounded),
                                      Text(
                                        'Call agency',
                                        style: TextStyle(
                                            fontSize: size.width * 0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Offer like dislik
  void handlePostLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);

    if (response.error == null) {
      detais();
    } else if (response.error == unauthorized) {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  listCategories() {
    List<Widget> lists = List.generate(
        equipements.length,
        (index) => Equip(
              data: equipements[index],
              offer: offer,
            ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        children: lists,
      ),
    );
  }

  listComments() {
    List<Widget> lists = List.generate(
        showComments.length,
        (index) => Comments(
              data: showComments[index],
            ));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5),
      child: Row(children: lists),
    );
  }

  void getNum() async {
    ApiResponse response = await num(offer!.agency_id);
    if (response.error == null) {
      phone = response.data;
      phone = phone[0]['phone'];
    }
  }

  // Get comments
  Future<void> _getComments() async {
    showComments.clear;
    _commentsList.clear;
    ApiResponse response = await getComments(offer!.id!);
    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        for (int i = 0; i < _commentsList.length; i++) {
          comment = Comment.fromJson(_commentsList[i]);
          showComments.add(comment);
        }
      });
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(unauthorized)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // set comments
  Future<void> _setComment() async {
    userId = await getUserId();
    ApiResponse response = await createComment(
      offer!.id!,
      newComment,
    );
    if (response.error == null) {
      setState(() {
        detais();
      });
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(unauthorized)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add comment'),
          content: TextField(
            onChanged: (value) {
              newComment = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter your comment',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    setState(() {
                      showComments.clear;
                      _commentsList.clear;
                    });
                  });
                  _setComment().then((value) => Navigator.pop(context));
                },
                child: Text('Submit'))
          ],
        ),
      );

  // Get Images
  Future<void> _getImages() async {
    ApiResponse response = await getImages(offer!.id!);
    if (response.error == null) {
      setState(() {
        getimgs = response.data as List<dynamic>;
        for (int i = 0; i < getimgs.length; i++) {
          img = getimgs[i];
          showImages.add(img["image"]);
        }
      });
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(unauthorized)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
}
