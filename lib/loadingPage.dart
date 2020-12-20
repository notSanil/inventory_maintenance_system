import 'package:flutter/material.dart';


class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey, //TODO: Change color acc to color scheme
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            backgroundColor: Colors.indigo[600],
          ),
        ),
      ),
    );
  }
}