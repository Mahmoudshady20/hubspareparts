import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:safecart/utils/custom_preloader.dart';

import '../../services/terms_and_condition_service.dart';
import 'custom_app_bar.dart';

class WebViewScreen extends StatelessWidget {
  static const String routeName = 'web view screen';
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final title = routeData[0];
    String url = routeData[1];
    return Scaffold(
        appBar: CustomAppBar().appBarTitled(context, title, () {
          Navigator.of(context).pop();
        }),
        body: FutureBuilder(
          future: Provider.of<TermsAndCondition>(context, listen: false)
              .getTermsAndCondi(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: SizedBox(height: 60, child: CustomPreloader())),
                ],
              );
            }
            if (snapshot.hasData) {}
            return Consumer<TermsAndCondition>(
              builder: (context, tService, child) {
                return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: HtmlWidget(tService.html));
              },
            );
          },
        ));
  }
}
