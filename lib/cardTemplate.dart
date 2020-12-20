import 'dart:collection';
import 'cardPage.dart';
import 'maintenanceRecord.dart';
import 'dataLib.dart';
import 'package:flutter/material.dart';

class CardTemplate extends StatelessWidget {
  final Data data = Data();

  CardTemplate(LinkedHashMap dat)
  {
    data.name = dat['prodName'];
    data.id = dat['id'];
    data.desc = dat['desc'];
    data.warranty = dat['warranty'];
    data.comments = dat['comments'];
    data.records = [];

    // Records handling
    if (dat['records'] != null){
      for (int i=0;i<dat['records'].length;i++){
        LinkedHashMap currRec = dat['records'][i];
        MainRec rec = MainRec(
          personName: currRec['personName'],
          dateOfMain: currRec['dateOfMain'],
          price: currRec['price'],
          mainDesc: currRec['mainDesc']
        );
        data.records.add(rec);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          subtitle: Text(
              data.id,
            style: TextStyle(
              fontSize: 16
            ),
          ),
          title: Text(
            data.name,
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),

          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CardPage(
                name: data.name,
                id: data.id,
                desc: data.desc,
                warranty: data.warranty,
                records: data.records,
                comments: data.comments,)));
        },
      )
    );
  }
}

