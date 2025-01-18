import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';
import '../../utils/responsive.dart';

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: ExpandableNotifier(
        //     initialExpanded: false,
        //     child: ExpandablePanel(
        //         // controller: _expandableController,
        //         // theme: const ExpandableThemeData(hasIcon: false),
        //         collapsed: const Text(''),
        //         header: Container(
        //           padding: const EdgeInsets.only(bottom: 2),
        //           child: Text(
        //             asProvider.getString('Additional Information'),
        //             maxLines: 1,
        //             overflow: TextOverflow.ellipsis,
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .titleMedium!
        //                 .copyWith(fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //         expanded:
        Container(
      //Dropdown
      margin: const EdgeInsets.only(bottom: 20, top: 8),
      child: Builder(builder: (context) {
        return Table(
          border: TableBorder.all(color: cc.pureGrey),
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(64),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Container(
                  width: screenWidth / 2.3,
                  padding: const EdgeInsets.all(3),
                  child: Text('sdafdf sdff',
                      style: TextStyle(color: cc.greyParagraph)),
                ),
                // TableCell(
                //   verticalAlignment:
                //       TableCellVerticalAlignment.top,
                //   child: Container(
                //     height: 32,
                //     // width: 32,
                //     color: Colors.red,
                //   ),
                // ),
                Container(
                  width: screenWidth / 2.3,
                  padding: const EdgeInsets.all(3),
                  child: Text('fasfdaf sdf fds s sfasd dsf sadfsdf sfsd fsaf',
                      style: TextStyle(color: cc.greyParagraph)),
                ),
              ],
            ),
            // TableRow(
            //   decoration: const BoxDecoration(
            //     color: Colors.grey,
            //   ),
            //   children: <Widget>[
            //     Container(
            //       height: 64,
            //       width: 128,
            //       color: Colors.purple,
            //     ),
            //     Container(
            //       height: 32,
            //       color: Colors.yellow,
            //     ),
            //     Center(
            //       child: Container(
            //         height: 32,
            //         width: 32,
            //         color: Colors.orange,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        );
      }
          // ))),
          ),
    );
  }
}
