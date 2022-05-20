// ignore_for_file: unused_import, curly_braces_in_flow_control_structures, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memoire/widgets/filter_list_item.dart';

class FilterList extends StatefulWidget {
  final Function(List<String>)? onSelect;

  const FilterList({Key? key, this.onSelect}) : super(key: key);

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  List<String> selected = [];
  List<dynamic> options = [
    {
      'icon': SvgPicture.asset("assets/icons/night.svg",width: 24,height: 24,),
      'title': 'Night',
    },
    {
      'icon': SvgPicture.asset("assets/icons/calendar.svg"),
      'title': 'Month'
    },
    {
      'icon': SvgPicture.asset("assets/icons/year.svg",width: 24,height: 24,),
      'title': 'Year'
    },
  ];

  toggle(title) {
    if (selected.contains(title))
      selected.remove(title);
    else
      selected.add(title);

    setState(() {
      widget.onSelect!(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((filter) {
        return FilterListItem(
          icon: filter['icon'],
          title: filter['title'],
          selected: this.selected.contains(filter['title']),
          onTap: () {
            toggle(filter['title']);
          },
        );
      }).toList(),
    );
  }
}
