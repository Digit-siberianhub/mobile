import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilef2/screens/singin_screen.dart';
import 'package:mobilef2/style/color_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
        primaryColor: ColorConstants.primaryColor,
      ),
      title: 'Flutter Demo',
      home: SigninScreen(),
    );
  }
}
