// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers, avoid_print, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoire/theme/color.dart';
import 'package:memoire/widgets/filter_list.dart';

class FilterModalBottomSheet extends StatelessWidget {
  void close(context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(28.0),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: Icon(Icons.settings_backup_restore_outlined,color: cardColor,),
                    onTap: () {
                      close(context);
                    },
                  ),
                ),
                Text(
                  'Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Icon(Icons.close),
                    onTap: () {
                      close(context);
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Range',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    width: ((size.width / 2) - 55),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Min',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                    height: 1,
                    color: Colors.black38,
                  ),
                  Container(
                    width: ((size.width / 2) - 55),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Max',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Per',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              child: FilterList(onSelect: (selected) => print(selected)),
            ),
            
            Container(
              width: size.width ,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8,50),
                   shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                primary: Colors.black,
                padding: EdgeInsets.all(20),
                ),
                child: Text('Apply Filter', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  close(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
