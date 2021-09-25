import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mobilef2/screens/singin_screen.dart';
import 'package:mobilef2/style/color_constants.dart';

void main() async {
  // var location = Location();
  // var serviceEnabled = await location.serviceEnabled();
  // if (serviceEnabled) {
  //   serviceEnabled = await location.requestService();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          color: ColorConstants.secondaryColor,
        ),
        primaryColor: ColorConstants.primaryColor,
      ),
      title: 'Flutter Demo',
      home: SigninScreen(),
    );
  }
}
