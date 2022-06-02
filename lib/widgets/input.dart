// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors, unused_field, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable, camel_case_types, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/utils/data.dart';
import 'animation.dart';
import 'recommend_item.dart';


class ToggleButton extends StatefulWidget {
  ToggleButton({ required this.title});
  final String title;
  int toggleValue = 0;
  static int togglevalue = 0 ;
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedToggle(
      values: ['Agency', 'Client'],
      onToggleCallback: (value) {
        setState(() {
          widget.toggleValue = value;
          print(widget.toggleValue);
          ToggleButton.togglevalue = widget.toggleValue;
        });
      },
      buttonColor: Colors.black,
      backgroundColor: const Color(0xFFB5C1CC),
      textColor: const Color(0xFFFFFFFF),
    );
  }
}


class Textfield extends StatelessWidget {
  
  Textfield(this.headerText,{this.child,});
    String headerText;
    Widget? child;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: size.height/22,
          margin: const EdgeInsets.only(
            left: 20,
          ),
          child: Text(
            headerText,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: size.height/15,
          margin: EdgeInsets.only(left: 20, right: 20,),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: child,
          ),
        ),
      ],
    );
  }
}


class mdps extends StatefulWidget {
  mdps({ Key? key,required this.headerText,this.hintTexti, this.child}) : super(key: key);
String headerText;
  String? hintTexti;
  Widget? child;
  @override
  State<mdps> createState() => _mdpsState();
}

class _mdpsState extends State<mdps> {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: size.height/22,
          margin: const EdgeInsets.only(
            left: 20,
          ),
          child: Text(
            widget.headerText,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: size.height/15,
          margin: EdgeInsets.only(left: 20, right: 20,),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}


class RoundedIconButton extends StatelessWidget {
  RoundedIconButton({required this.icon, required this.onPress, required this.iconSize});

  final IconData icon;
  final Function() onPress;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize),
      elevation: 6.0,
      onPressed: onPress,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(iconSize*0.4)),
      fillColor: mainColor,
      child: Icon(
        icon,
        color: Colors.white,
        size: iconSize * 0.8,
      ),
    );
  }
}


class CustomStepper extends StatefulWidget {
  CustomStepper({
    required this.lowerLimit,
    required this.upperLimit,
    required this.stepValue,
    required this.iconSize,
    required this.value, required this.titre,
  });

  final int lowerLimit;
  final String titre;
  final int upperLimit;
  final int stepValue;
  final double iconSize;
  int value;
  static int rooms = 0 ;
  static int bed = 0 ;
  static int bathroom = 0  ;
  static int visitors = 0 ;
  static late int vl;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    CustomStepper.vl = widget.value;
    return Column(
      children: [
        Text(widget.titre,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedIconButton(
              icon: Icons.remove,
              iconSize: widget.iconSize,
              onPress: () {
                setState(() {
                  widget.value =
                      widget.value == widget.lowerLimit ? widget.lowerLimit : widget.value -= widget.stepValue;
                      CustomStepper.vl = widget.value;
                      type();
                });
                
              },
            ),
            Container(
              width: widget.iconSize,
              child: Text(
                '${CustomStepper.vl}',
                style: TextStyle(
                  fontSize: widget.iconSize * 0.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RoundedIconButton(
              icon: Icons.add,
              iconSize: widget.iconSize,
              onPress: () {
                setState(() {
                  widget.value =
                      widget.value == widget.upperLimit ? widget.upperLimit : widget.value += widget.stepValue;
                      CustomStepper.vl = widget.value;
                      type();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  type() {
    switch (widget.titre) {
      case 'Rooms':
        CustomStepper.rooms = CustomStepper.vl;
        break;
      case 'bed':
        CustomStepper.bed = CustomStepper.vl;
        break;
      case 'bathroom':
        CustomStepper.bathroom = CustomStepper.vl;
        break;
      case 'visitors':
        CustomStepper.visitors = CustomStepper.vl;
        break;
      default:
    }
  } 

}

class Tgl extends StatefulWidget {
  const Tgl({ Key? key }) : super(key: key);
  static bool? Rent;
  static bool? Sell;
  static bool? vacation;
  @override
  State<Tgl> createState() => _TglState();
}

class _TglState extends State<Tgl> {
  var isSelected1 = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
                selectedColor: appBarColor,
                fillColor: primary,
                borderRadius: BorderRadius.circular(45),
                  onPressed: (int index) {
                    setState(() {
                      isSelected1[index] = !isSelected1[index];
            
                      if (isSelected1[index] == true && index == 0) {
                        Tgl.Rent = true;
                      }
                      if (isSelected1[index] == false && index == 0) {
                        Tgl.Rent = false;
                      }
            
                      if (isSelected1[index] == true && index == 1) {
                        Tgl.Sell = true;
                      }
                      if (isSelected1[index] == false && index == 1) {
                        Tgl.Sell = false;
                      }
            
                      if (isSelected1[index] == true && index == 2) {
                        Tgl.vacation = true;
                      }
                      if (isSelected1[index] == false && index == 2) {
                        Tgl.vacation = false;
                      }
                    });
                  },
                  isSelected: isSelected1,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text('Rent',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text('Sell',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 27),
                      child: Text('Vacation',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                    ),
                  ],
              );
  }
}


class Daye extends StatefulWidget {
  Daye({ Key? key }) : super(key: key);

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(), end: DateTime.now(),
    );

  static var start ;
  static var end;
  @override
  State<Daye> createState() => _DayeState();
}

class _DayeState extends State<Daye> {
  
  @override
  Widget build(BuildContext context) {
     Daye.start = widget.dateRange.start;
     Daye.end = widget.dateRange.end;
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.date_range_outlined),
                  onPressed: pickDateRange,
                ),

                GestureDetector(
                  onTap: pickDateRange,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: primary,
                    ),
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: Center(child: Text(DateFormat('yyyy / MM / dd').format(Daye.start),textAlign: TextAlign.center,style: TextStyle(color: appBarColor),)),
                  ),
                ),

                GestureDetector(
                  onTap: pickDateRange,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: primary,
                    ),
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: Center(child: Text(DateFormat('yyyy / MM / dd').format(Daye.end),textAlign: TextAlign.center,style: TextStyle(color: appBarColor),)),
                  ),
                ),
              ],
            ),
    );
  }
  Future pickDateRange() async{
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
      initialDateRange: widget.dateRange,
      );
      if (newDateRange == null) return;
      setState(()=> widget.dateRange = newDateRange);
  }
}



class LogementType extends StatefulWidget {
  const LogementType({ Key? key }) : super(key: key);
  static String logement_type = '';
  @override
  State<LogementType> createState() => _LogementTypeState();
}

class _LogementTypeState extends State<LogementType> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
                mainAxisSpacing:size.height * 0.02 ,
                crossAxisSpacing : size.width * 0.1 ,
                padding: EdgeInsets.all(size.width * 0.05 ),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: <Widget>[
                  for (int i = 0; i < logement.length; i++)
                     MonthOption(
                        logement[i]['type']! as String ,
                        img: logement[i]['img']! as String  ,
                        onTap: () => checkOption(i + 1),
                        selected: i + 1 == optionSelected,
                      ),
                ],
              );
  }
  int optionSelected = 0;
    void checkOption(int index) {
      setState(() {
        optionSelected = index;
        switch (optionSelected) {
          case 1:
            LogementType.logement_type = 'Apparetemnt';
            break;
          case 2:
            LogementType.logement_type = 'Villa';
            break;
          case 3:
            LogementType.logement_type = 'Garage';
            break;
          case 4:
            LogementType.logement_type = 'studio';
            break;
        }
      });
    }
}


class Images extends StatefulWidget {
  const Images({ Key? key}) : super(key: key);
  static List<XFile> listImage= [];
  static List listPath = [];

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {

  final ImagePicker _picker = ImagePicker();

    selectImages() async{
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        Images.listImage.addAll(selectedImages);
      }
      for (var i = 0; i < Images.listImage.length; i++) {
        Images.listPath.add(Images.listImage[i].path);
        print(Images.listImage[i].path);
      }
      setState(() { });
    }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Column(
        children: [
          OutlinedButton(
              onPressed: (){ selectImages();},
              style: OutlinedButton.styleFrom(
                fixedSize: Size(size.width * 0.75, size.height * 0.07),
                elevation: 10,
                primary: white,
                backgroundColor: primary.withOpacity(0.9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("select your property's images",
                    style:TextStyle(
                        color: white, fontSize: size.width * 0.045, fontWeight: FontWeight.w500),
                  ),
                  Icon(Icons.add_a_photo_outlined, color: white),
                ],
              )
            ),

            SizedBox(height: 20,),

          Container(
           child: Images.listImage.isEmpty ?  Container(
              decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),border: Border.all(color: primary)),
              height: 100,
              width: size.width * 0.8,
              child: Icon(Icons.add_photo_alternate_rounded,size: 50,color: primary.withOpacity(0.8),),
            ):Container(
              decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),border: Border.all(color: primary)),
              height: 250,
              padding: EdgeInsets.all(4),
              margin:  EdgeInsets.all(8),
              width: size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),      
                child: Align(alignment: Alignment.bottomRight,
                  heightFactor: 0.3,
                  widthFactor: 2.5,
              child:GridView.builder(
                itemCount: Images.listImage.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    child: Image.file(File(Images.listImage[index].path),fit: BoxFit.cover,),
                    onTap: () {
                      Images.listImage.removeAt(index);
                    },
                  );
                }
              ),
            ),))
          ),
        ]
    );
  }
}