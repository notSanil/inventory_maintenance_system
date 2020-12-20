import 'qrScan.dart';
import 'form.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'cardPage.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
      '/': (BuildContext context) => Home(),
      '/qr_page':(BuildContext context) => qrPage(),
      '/form_page': (BuildContext context) => FormPage(),
      '/card_page' : (BuildContext context) => CardPage(),
      },
      title: "Inventory Maintenance System",
    );
  }
}

