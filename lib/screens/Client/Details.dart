// ignore_for_file: sized_box_for_whitespace, deprecated_member_use, file_names, use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_comparison

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offer.dart';
import 'package:memoire/Services/user.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/widgets/Map.dart';

import 'package:memoire/widgets/category_item.dart';
import 'package:memoire/widgets/icon_box.dart';
import 'package:memoire/widgets/property_item.dart';
import 'package:memoire/widgets/rate.dart';
import 'package:readmore/readmore.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({ Key? key, required this.id }) : super(key: key);
  final int id;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;
  int userId = 0;
  bool _loading = true;
  Offer? offer;
  List<dynamic> data= [];
  double? longitude;
  double? latitude;
  LatLng? lo;

  Future<void> detais() async {
    userId = await getUserId();
    ApiResponse response = await getDetailsOffer(widget.id);
    if(response.error == null){
      setState(() {
        data = response.data as List<dynamic> ;
        for (int i= 0 ;i < data.length ; i++) {
            offer = Offer.fromJson(data[i]);        
        }
        _loading = false;
        latitude = offer!.latitude!;
        longitude = offer!.longitude!;
        lo = LatLng(latitude!, longitude!);
      });
    }
    else if (response.error == unauthorized){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(unauthorized),
      ));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    detais();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return detais();
        },
        child:Scaffold(
          body: _loading ? Center(child: CircularProgressIndicator()) :
          ListView(
            children: <Widget>[
              
              //photos & Favorite
              Stack(
                children: [
                  //photos
                  Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: size.height * 0.3,
                  width: size.width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 10),
              
                    ),
                    items: List.generate(images.length, (index) => Photos(data: images[index],marg: 10.0))
                  ),
                  ),

                  //Favorite
                  Positioned(
                  bottom: 11,right: 15,
                  child: IconBox(
                  bgColor: cardColor.withOpacity(0.9),
                  pad: 3,
                  onTap: (){handlePostLikeDislike(offer!.id!);
                    setState(() {
                      switch (offer!.selfLiked) {
                        case true:
                          offer!.selfLiked = false;
                        break;
                        case false:
                          offer!.selfLiked = true;
                        break;
                      }
                    });},
                  child:
                   Icon( offer!.selfLiked == true ? Icons.favorite : Icons.favorite_border,
                   color: actionColor, size: size.width * 0.09,
                  ),
                  )
                ),
                ],
              ),

              //body
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                          child: Text( "${offer!.name}",
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
                              "${offer!.price} 000 \$",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w900,
                                color: Colors.green.shade600
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                        ),
                      ],
                    ),

                    //Rating
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                      child: SmoothStarRating(
                        starCount: 5,
                        color: ratingBG,
                        allowHalfRating: true,
                        rating: 4.0,
                        size: 15.0, borderColor: primary, onRatingChanged: (double rating) {  },
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
                    ReadMoreText( "${offer!.description}",
                                    style: TextStyle(color: textColor,fontSize: 14,
                                      fontWeight: FontWeight.w300,),
                                    trimLines: 4,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Hide',
                                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: darker),
                                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: red),
                                    ),
                    SizedBox(height: 20.0),

                    //Location
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.black,),
                        //address
                        Container(
                          width: size.width * 0.8,
                          child: Text( "${offer!.location}",
                            style: TextStyle(
                              fontSize: 18,
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
                      height: size.height * 0.3,
                      child :ClipRRect(
                        borderRadius: BorderRadius.circular(35),      
                        child: Align(alignment: Alignment.bottomRight,
                          heightFactor: 0.3,
                          widthFactor: 2.5,
                          child: Maps(loca: lo!, location: offer!.location!,)),
                        ),),
                    SizedBox(height: 20.0),
                    Text("Comments",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),),
                      SizedBox(height: 20.0),
                    listComments(),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
      ),
    ),);
  }

  // Offer like dislik
  void handlePostLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);

    if(response.error == null){
      detais();
    }
    else if(response.error == unauthorized){
      print(unauthorized);
    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }


  listCategories(){
    List<Widget> lists = List.generate(equipements.length, 
      (index) => Equip(data: equipements[index],
      )
    );
    return
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 5),
        child: Row(
          children: lists
        ),
      );
  }


  listComments(){
    Size size = MediaQuery.of(context).size;
    List<Widget> lists = List.generate(comments.length, 
      (index) => 
      Container( 
        margin: EdgeInsets.only(right: 15),
        height: size.height * 0.155, width:size.width * 0.9,
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          tileColor: Colors.grey.shade300,
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: AssetImage( "${comments[index]['img']}",),
                                    ),
                                  ],
                                ),
                        
                                title: Text("${comments[index]['name']}"),
                                subtitle: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SmoothStarRating(
                                          starCount: 5,
                                          color: ratingBG,
                                          allowHalfRating: true,
                                          rating: 5.0,
                                          size: 12.0, borderColor: mainColor, onRatingChanged: (double rating) {  },
                                        ),
                                        SizedBox(width: 6.0),
                                        Text(  "February 14, 2020",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7.0),
                                    ReadMoreText( "${comments[index]["comment"]}",
                                    style: TextStyle(color: textColor),
                                    trimLines: 2,
                                    colorClickableText: red,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Hide',
                                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: darker),
                                    ),
                                  ],
                                ),
                            ),
      ),
    );
    return
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 5),
        child: Row(
          children: lists
        ),
      );
  }
}