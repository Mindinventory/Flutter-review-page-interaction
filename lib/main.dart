import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///Users/dhruv/Projects/Flutter-review-page-interaction/expression_emoji/lib/app_color.dart';

import 'review_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: AppColors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.white,
        body: MyReviewPage(),
      ),
    );
  }
}
