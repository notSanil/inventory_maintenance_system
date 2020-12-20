import 'package:flutter/material.dart';
import 'loadingPage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'cardTemplate.dart';
import 'qrScan.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  final String fileName = 'userData.json';
  List jDat;

  @override
  void initState(){
    super.initState();
    readFiles();
  }

  readFiles() async{
    setState(() {
      _isLoading = true;
    });

    Directory dir = await getExternalStorageDirectory();

    File jsonFile = File('${dir.path}/$fileName');
    if (!await jsonFile.exists()){
      jsonFile.create();
      jDat = [];
      jsonFile.writeAsString(json.encode(jDat));
    }
    else{
      String data = await jsonFile.readAsString();
      jDat = json.decode(data);
    }
    print(jDat);
    setState(() {
      _isLoading = false;
    });

  }



  List<Widget> createList() {
    List<Widget> boxes = [];
    for (int i = 0;i < jDat.length;i++) {
      CardTemplate newCard = CardTemplate(jDat[i]);
      boxes.add(newCard);
    }
    return boxes;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingPage() : Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text("Home"),
        backgroundColor: Colors.cyan[900],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: createList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>qrPage()));
          },
        child: Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.cyan[900],
      ),
    );
  }
}
