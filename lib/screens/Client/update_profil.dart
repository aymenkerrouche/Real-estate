// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_typing_uninitialized_variables, sized_box_for_whitespace, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memoire/Services/Api.dart';
import 'package:memoire/screens/root_app.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';


import 'package:memoire/widgets/input.dart';


class UpadateProfil extends StatefulWidget {
  const UpadateProfil({ Key? key }) : super(key: key);

  @override
  State<UpadateProfil> createState() => _UpadateProfilState();
}

class _UpadateProfilState extends State<UpadateProfil> {
  var name;
  var email;
  var password;
  bool _visible = true;


  void _startTimer() {
    Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>RootApp(usertype: usertype )), (route) => false);
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Container(
          height: size.height ,
          child: Column(
            children: [

               //appBar
              Container(height: size.height * 0.1,
              margin: EdgeInsets.only(top: size.height * 0.06),
              child: Text('Update your Profle',style: TextStyle(
                fontSize: size.width * 0.08,
                fontWeight: FontWeight.w500,
                color: cardColor
              ),),),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45), topRight: Radius.circular(45)),
                    color: appBarColor
                          ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            //Name
                            Textfield('User name',child: TextFormField(
                              onChanged: (value) { name = value;},
                              decoration: InputDecoration(
                                hintText: profile["name"],
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.person, color: Colors.black,),
                              ),
                            ),),
                            SizedBox(height: 20,),

                            //Email
                            Textfield('Email',child: TextFormField(
                              onChanged: (value) { email = value;},
                                decoration: InputDecoration(
                                  hintText: profile["email"],
                                  border: InputBorder.none,
                                  suffixIcon: Icon(Icons.email_outlined, color: Colors.black,),
                                ),
                              ),),
                            SizedBox(height: 20,),
              
                            //password
                            mdps(headerText: "Password",child: TextFormField(
                              obscureText: _visible,
                              onChanged:  (value) { password = value;},
                              decoration: InputDecoration(
                                hintText: '********',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.only(bottom: 5),
                                  icon: Icon(_visible ? Icons.visibility : Icons.visibility_off, color: Colors.black,),
                                  onPressed: () {setState(() { _visible = !_visible ; });}
                                )
                              ),
                            ),),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: size.width/10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width ,size.height/13),
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () {updateProfile();},
                          child:  Text('Update', style: TextStyle( fontFamily: 'Poppins', fontSize: 20, color: white,fontWeight: FontWeight.w500,),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }  

  //update profile
  void updateProfile() async {
    ApiResponse response = await updateUser(name, email, password);
    if(response.error == null){
      
      snkBar(response, Colors.green.shade600, response.data.toString(),'Close,', primary, (){},2);
      setState(() {
        if (name != null && name != '') {
          profile["name"]=name;
          user!.name = name;
          print(name);
        }
        if (email != null && email != '') {
          profile["email"]=email;
          user!.email = email;
          print(email);
        }
      });
      _startTimer();
    }
    else if(response.error == unauthorized){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(unauthorized)
      ));
    }
    else {
        snkBar(response, Colors.grey, response.error,'ok,', red, (){},3);
    }
  }





  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snkBar(ApiResponse response, Color color, String? text,String ok, Color okcolor, Function() ontap,int s) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color.withOpacity(0.5),
        content: Text('$text',style: TextStyle(color: primary),),
        action: SnackBarAction(label: 'OK',onPressed: ontap ,textColor: okcolor),
        elevation: 50,
        duration: Duration(seconds: s),
        shape: StadiumBorder(side: BorderSide.none),
        behavior: SnackBarBehavior.floating,
    ));
  }
}