import 'package:flutter/cupertino.dart';

class IntroHelper with ChangeNotifier {
  List<Map<String, String>> introData = [
    {
      'introTitle': 'Find The Best Collection Easily with Nexelit',
      'description':
          'Get your all the dream product easily by your choice. Let’s start with nexelit ecommerce website.',
      'imagePath': 'assets/images/intro_image-1.png',
    },
    {
      'introTitle': 'Save up to 50% of Our so Many Offers',
      'description':
          'Get your all the dream product easily by your choice. Let’s start with nexelit ecommerce website. ',
      'imagePath': 'assets/images/intro_image-2.png',
    },
    {
      'introTitle': 'Delivery all the product within Our Fixed Date',
      'description':
          'Get your all the dream product easily by your choice. Let’s start with nexelit ecommerce website.',
      'imagePath': 'assets/images/intro_image-3.png',
    }
  ];
  int currentIndex = 0;
  setIndex(value) {
    currentIndex = value;
    notifyListeners();
  }
}
