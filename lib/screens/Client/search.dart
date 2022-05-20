// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, unused_element, unrelated_type_equality_checks, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/Services/offer.dart';
import 'package:memoire/Services/user.dart';
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




class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


 List _postList = [];
  int userId = 0;
  bool _loading = true;
  late Offer offer;
  List offers = [];

  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getOffers();
    offers.clear();
    if(response.error == null){
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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
    offers.clear();
    for (int i= 0 ;i < _postList.length ; i++) {
          offer = Offer.fromJson(_postList[i]);
          offers.add(offer);
        }
  }
  
  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return  SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return retrievePosts();
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
                        Container(child: listCategories(),)
                      ],
                    ),
                  ),
                )
                
               
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => buildBody(),
                  childCount: 1,
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget getAppBar(){ 
    Size size = MediaQuery.of(context).size;
    return
      Row(
        children: [
          Container(width: size.width * 0.1,height:50,child: Image.asset("assets/applogo.png",fit: BoxFit.contain,)),
          SizedBox(width: 10,),
          Expanded(
            child: CustomTextBox(hint: "Search", prefix: SvgPicture.asset('assets/icons/search.svg', color: inActiveColor,fit: BoxFit.scaleDown,), )
          ),
          SizedBox(width: 10,),
          IconBox(child: SvgPicture.asset('assets/icons/filter.svg', color: primary,), radius: 10,pad: 7 ,onTap: () => showModalBottomSheet(context: context, builder:(context) => Container(color: red,),),)
        ],
      );
  }

  buildBody(){
    Size size = MediaQuery.of(context).size;
    return
      Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02,horizontal: size.width * 0.04),
        child: Column(
          children:[listFavorite(),]
        ),
      );
  } 

  listFavorite(){
    List<Widget> lists = List.generate(offers.length, 
      (index) => PropertyItem(data: offers[index], height: 140.0,marg: 30.0,
      ontap: (){
        offer = offers[index];
        Navigator.push( context, MaterialPageRoute( builder: (context) => ProductDetails(id: offer.id!,),),);
      },
      onTap: () {
        offer = offers[index];
        handlePostLikeDislike(offer.id!);
        switch (offer.selfLiked) {
          case true:
            offer.selfLiked = false;
            break;
          case false:
            offer.selfLiked = true;
            break;
        }
      },
      )
    );
    
    return 
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: lists
        ),
    );
  }


  int selectedCategory = -1;
  listCategories(){
    List<Widget> lists = List.generate(filter.length, 
      (index) => Filter(data: filter[index], selected: index == selectedCategory,
        onTap: (){
          setState(() {
            selectedCategory =  index;
            switch (selectedCategory) {
              case 0 :
                 _settingModalBottomSheet(context);
                break;
              case 3 :
                  showModalBottomSheet(
                    enableDrag: false,
                    context: context,
                    builder: (context) =>  MapPage(),
                  );
                break;
              default:
            }
          });
        },
      )
    );
    return
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only( top: 10,left: 15),
        child: Row(
          children: lists
        ),
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
        return FilterModalBottomSheet();
      });
  }

   
// Offer like dislik
  void handlePostLikeDislike(int id) async {
    ApiResponse response = await likeUnlikeOffer(id);

    if(response.error == null){
      retrievePosts();
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
}