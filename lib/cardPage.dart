import 'maintenanceRecord.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'form.dart';

class CardPage extends StatelessWidget {
  final String name;
  final String id;
  final String desc; // Optional
  final bool warranty;
  final String comments;
  final List<MainRec> records;
  CardPage({this.name, this.id, this.desc, this.warranty, this.records, this.comments});

  Widget checkForNone(String check, String checkedVar){
    if (check.isEmpty){
      return Text(
          "$checkedVar: None Provided",
          style: TextStyle(
            fontSize: 20.0,
          )
      );
    }
    else
      return Text("$checkedVar : $check",
          style: TextStyle(
            fontSize: 20.0,
      )
      );

  }
  List<Widget> recordUnpacking(){
    List<Widget> recordFinal = [];


    for (int i = 0; i < records.length; i++){
      Widget tempContain = Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Maintainer's Name: ${records[i].personName}",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              Text("Date of Maintenance: ${records[i].dateOfMain}",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text("Cost of Maintenance: ${records[i].price}",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              checkForNone(records[i].mainDesc, "Maintenance Description"),
            ]
          )
      );
      recordFinal.add(tempContain);
      recordFinal.add(SizedBox(height: 5,));
    }
    return recordFinal;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Text(this.name),
        backgroundColor: Colors.cyan[900],
      ),
      backgroundColor:  Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0),
        child: ListView(
          children: [
            Container(
              child: Text(
                "ID: ${this.id}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                )
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.all(5),
            ),
            SizedBox( height: 5.0, ),
            Container(
                child: checkForNone(this.desc,"Description"),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            SizedBox( height: 5.0, ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius:BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text("Warranty: ${this.warranty.toString()}",
                    style: TextStyle(
                      fontSize: 20.0,
                    )
                )
            ),
            SizedBox(height: 5.0,),
            Container(
              child: checkForNone(this.comments,"Comments"),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            SizedBox(height: 10)
          ] + recordUnpacking(),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan[900],
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FormPage(id: this.id, isCard: true)));
        },
      ),

      );
  }
}
