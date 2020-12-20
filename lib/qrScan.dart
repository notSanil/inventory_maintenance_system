import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'form.dart';
import 'loadingPage.dart';

class qrPage extends StatefulWidget {
  @override
  _qrPageState createState() => _qrPageState();
}

class _qrPageState extends State<qrPage> {
  @override
  void initState(){
    super.initState();
    _scanCode();
  }
  bool _camState = false;
  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  _qrCallback(String code) {
    setState(() {
      _camState = false;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FormPage(id: code, isCard: false,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan a QR Code"),
        backgroundColor: Colors.cyan[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
           onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
           },
        ),
      ),
      body:  _camState
            ? Center(
            child: SizedBox(
            width: 512,
              height: 1024,
              child: QrCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  _qrCallback(code);
                },
              ),
            ),
            )
        : LoadingPage(),
    );
  }
}