import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

class FilterOption extends StatefulWidget {
  String hintText;
  String selectedOption;
  List<String> itemList;
  FilterOption(this.hintText, this.selectedOption, this.itemList, {super.key});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 15, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: cc.greyBorder,
          width: 1,
        ),
      ),
      child: DropdownButton(
        hint: Text(
          widget.hintText,
        ),
        underline: const SizedBox(),
        elevation: 0,
        value: widget.selectedOption,
        style: TextStyle(color: cc.greyHint),
        icon: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: cc.greyHint,
        ),
        onChanged: (value) {
          setState(() {
            widget.selectedOption = value as String;
          });
        },
        items: widget.itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.centerLeft,
            value: value,
            child: SizedBox(
              // width: MediaQuery.of(context).size.width - 83,
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
