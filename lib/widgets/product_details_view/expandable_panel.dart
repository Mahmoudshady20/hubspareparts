import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class Expandablepanel extends StatelessWidget {
  Widget header;
  Widget expanded;
  Expandablepanel(this.header, this.expanded, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: false),
        theme: const ExpandableThemeData(hasIcon: false),
        header: header,
        collapsed: const Text(''),
        expanded: expanded,
      ),
    );
  }
}
