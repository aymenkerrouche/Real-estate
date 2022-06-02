
// ignore_for_file: prefer_const_constructors, void_checks, library_private_types_in_public_api



import 'package:flutter/material.dart';
import 'package:memoire/screens/Client/account.dart';
import 'package:memoire/screens/Client/favorite.dart';
import 'package:memoire/screens/Client/search.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/bottombar_item.dart';
import 'Admin/agency_profil.dart';
import 'Admin/add_offer.dart';
import 'Client/home.dart';

class RootApp extends StatefulWidget {
  const RootApp({ Key? key, required this.usertype }) : super(key: key);
  final int usertype ;
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp>  with TickerProviderStateMixin{
      int activeTab = 0;
      List barItems = [
        {
          "icon" : "assets/icons/home.svg",
          "active_icon" : "assets/icons/home.svg",
          "page" : HomePage(),
        },
        {
          "icon" : "assets/icons/search.svg",
          "active_icon" : "assets/icons/search.svg",
          "page" : SearchPage(),
        },
        {
          "icon" : "assets/icons/heart.svg",
          "active_icon" : "assets/icons/play.svg",
          "page" : FavoritePage(),
        },
        {
          "icon" : "assets/icons/profile.svg",
          "active_icon" : "assets/icons/profile.svg",
          "page" : AccountPage(),
        },
      ];


      int activeTabAg = 0;
      List barItemsAg = [
        {
          "icon" : "assets/icons/home.svg",
          "active_icon" : "assets/icons/home.svg",
          "page" : HomePage(),
        },
        {
          "icon" : "assets/icons/search.svg",
          "active_icon" : "assets/icons/search.svg",
          "page" : SearchPage(),
        },
        {
          "icon" : "assets/icons/add.svg",
          "active_icon" : "assets/icons/play.svg",
          "page" : AddLogement(),
        },
        {
          "icon" : "assets/icons/profile.svg",
          "active_icon" : "assets/icons/profile.svg",
          "page" : AccountAg(),
        },
      ];




//====== set animation=====
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: ANIMATED_BODY_MS),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
     _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  animatedPage(page){
    return FadeTransition(
      child: page,
      opacity: _animation
    );
  }

  void onPageChanged(int index) {
     if (widget.usertype == 0) {
      activeTab = activeTabAg;
      barItems = barItemsAg;

    }
    _controller.reset();
    setState(() {
      activeTab = index;
    });
    _controller.forward();
  }

//====== end set animation=====

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      bottomNavigationBar: getBottomBar(),
      body: getBarPage()
    );
  }

  Widget getBarPage(){
    return 
      IndexedStack(
        index: activeTab,
        children: 
          List.generate(barItems.length, 
            (index) => animatedPage(barItems[index]["page"])
          )
      );
  }

  Widget getBottomBar() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bottomBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), 
          topRight: Radius.circular(25)
        ), 
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1, 1)
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15,),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(barItems.length, 
            (index) => BottomBarItem(
              barItems[index]["icon"], isActive: activeTab == index, activeColor: primary,
              onTap: (){
                 if (widget.usertype == 0) {
                    activeTab = activeTabAg;
                    barItems = barItemsAg;
                  }
                onPageChanged(index);
              },
            )
          )
        )
      ),
    );
  }

}



