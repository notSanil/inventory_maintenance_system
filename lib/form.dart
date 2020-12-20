import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'maintenanceRecord.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'homePage.dart';
import 'loadingPage.dart';
import 'cardPage.dart';

// This page is supposed to load up after the qr code page.

const String fileName = "userData.json";

class FormPage extends StatefulWidget {
  final String id;
  final bool isCard;
  FormPage({this.id, this.isCard});
  
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Widget currentPage = LoadingPage();
  
  @override
  void initState(){
    super.initState();
    decidePage();
  }

  List<MainRec> generateRecords(List records){
    List<MainRec> mainRecs = [];
    for (int i = 0; i < records.length;i++){

      MainRec record = MainRec(
        personName: records[i]['personName'],
        dateOfMain: records[i]['dateOfMain'],
        price: records[i]['price'],
        mainDesc: records[i]['mainDesc']
      );
      mainRecs.add(record);
    }
    return mainRecs;
  }
  
  void decidePage() async{
    Directory dir = await getExternalStorageDirectory();
    
    File file = File("${dir.path}/$fileName");

    String data = await file.readAsString();
    List decodedData = json.decode(data);

    for (int i = 0;i < decodedData.length;i++){
      String id = decodedData[i]['id'];
      if (id == this.widget.id){
        if (!this.widget.isCard){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CardPage(
            name: decodedData[i]['prodName'],
            comments: decodedData[i]['comments'],
            id: id,
            desc: decodedData[i]['desc'],
            warranty: decodedData[i]['warranty'],
            records: generateRecords(decodedData[i]['records']),
          )));
        }
        else{
          setState(() {
            currentPage = KnownPage(id: this.widget.id, ind: i);
          });
          return;
        }
      }
    }
    setState(() {
      currentPage = UnknownPage(id: this.widget.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}



class UnknownPage extends StatefulWidget {
  final String id;

  UnknownPage ({this.id});
  @override
  _UnknownPageState createState() => _UnknownPageState();
}

Map dat = {'prodName':'', 'id':'', 'desc':'', 'warranty': false, 'comments':'',
  'personName':'', 'dateOfMain':'', 'price':'', 'mainDesc':''};

class _UnknownPageState extends State<UnknownPage> {
  final _formKey = GlobalKey<FormState>();
  bool isWriting = false;
  writeToJsonFile(Map data) async{
    setState(() {
      isWriting = true;
    });
    Directory dir = await getExternalStorageDirectory();

    File file = File("${dir.path}/$fileName");
    if (!await file.exists()){
      file.create();
      List dat = [data, ];
      await file.writeAsString(json.encode(dat));
    }
    else{
      String oldData = await file.readAsString();
      List decodedOld = json.decode(oldData);
      decodedOld.add(data);
      await file.writeAsString(json.encode(decodedOld));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    }
    setState(() {
      isWriting = false;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
          },
        ),
        title: Text("Add new item"),
        backgroundColor: Colors.cyan[900],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFieldTemplate(
                labText: "Item name",
                hText: "Enter the item name",
                labIcon: Icons.home_repair_service,
                dataKey: 'prodName',
              ),
              SizedBox(height: 6.0,),
              TextFormField(
                readOnly: true,
                initialValue: this.widget.id,
                decoration: InputDecoration(
                  labelText : "ID",
                  icon: Icon(Icons.qr_code),
                  labelStyle: TextStyle(
                    fontSize: 22.0,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black
                    ),
                    gapPadding: 5.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3.5,
                    ),
                  ),
                ),
                onSaved: (value){
                  dat['id'] = value;
                },
              ),
              SizedBox(height: 6.0,),
              TextFieldTemplateOptional(
                labText: "Description(optional)",
                hText: "Enter the item description",
                labIcon: Icons.text_snippet,
                dataKey: 'desc',
              ),
              SizedBox(height: 6.0,),
              //Warranty text field
              TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText : "Warranty",
                    icon: Icon(Icons.insert_drive_file),

                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      color: Colors.blueGrey[700],
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: "Yes or No",
                    hintStyle: TextStyle(
                        fontSize: 20.0
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black
                      ),
                      gapPadding: 5.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 3.5,
                      ),
                    ),
                  ),
                  validator: (String value){
                    if (value.toLowerCase() !=  "yes" &&  value.toLowerCase() !=  "no"){
                      return "ERROR, enter Yes or No ";
                    }
                    return null;
                  },
                  onSaved: (value){
                    if (value.toLowerCase() == 'yes')
                    {
                      dat['warranty'] = true;
                    }
                    else if (value.toLowerCase() == 'no')
                    {
                      dat['warranty'] = false;
                    }
                  }
              ),
              SizedBox(height: 6.0,),
              TextFieldTemplateOptional(
                labText: "Comments(optional)",
                hText: "Optional",
                labIcon: Icons.comment,
                dataKey: "comments",
              ),
              SizedBox(height: 40.0,),

              TextFieldTemplate(
                labText: "Maintainer name",
                hText: "Enter the name of the person",
                labIcon: Icons.person,
                dataKey: 'personName',
              ),
              SizedBox(height: 6.0,),
              TextFieldTemplate(
                labText: "Date of Maintenance",
                hText: "Enter the date of record",
                labIcon: Icons.date_range,
                dataKey: 'dateOfMain',
              ),
              SizedBox(height: 6.0,),
              TextFieldTemplate(
                labText: "Cost of Maintenance",
                hText: "e.g. 1000",
                labIcon: Icons.attach_money,
                dataKey: 'price',
              ),
              SizedBox(height: 6.0,),
              TextFieldTemplateOptional(
                labText: "Details(optional)",
                hText: "Details of repair",
                labIcon: Icons.text_snippet,
                dataKey: 'mainDesc',
              ),

              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[900])),
                child:
                isWriting? Text("Submitting..."):Text("Submit"),
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Map record = {
                      'personName': dat['personName'],
                      'dateOfMain': dat['dateOfMain'],
                      'price': dat['price'],
                      'mainDesc': dat['mainDesc']
                    };
                    dat.remove('personName');
                    dat.remove('dateOfMain');
                    dat.remove('price');
                    dat.remove('mainDesc');
                    List records = [record,];
                    dat['records'] = records;
                    writeToJsonFile(dat);
                  }
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}


class KnownPage extends StatefulWidget {
  final String id;
  final int ind;
  KnownPage({this.id, this.ind});

  @override
  _KnownPageState createState() => _KnownPageState();
}

class _KnownPageState extends State<KnownPage> {
  final _knownFormKey = GlobalKey<FormState>();

  bool writing = false;

  void writeToJson(Map record) async{
    setState(() {
      writing = true;
    });

    Directory dir = await getExternalStorageDirectory();

    File file = File("${dir.path}/$fileName");

    String data = await file.readAsString();
    List decodedData = json.decode(data);
    decodedData[this.widget.ind]['records'].add(record);

    file.writeAsString(json.encode(decodedData));

    setState(() {
      writing = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
          },
        ),
        title: Text("Add a new record"),
        backgroundColor: Colors.cyan[900],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Form(
          key: _knownFormKey,
          child: ListView(
            children: [
              TextFormField(
                readOnly: true,
                initialValue: this.widget.id,
                decoration: InputDecoration(
                  labelText : "ID",
                  icon: Icon(Icons.qr_code),
                  labelStyle: TextStyle(
                    fontSize: 22.0,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black
                    ),
                    gapPadding: 5.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3.5,
                    ),
                  ),
                ),
                onSaved: (value){
                  dat['id'] = value;
                },
              ),
              SizedBox(height: 40.0,),


              TextFieldTemplate(
                labText: "Maintainer Name",
                hText: "Enter the name of the person",
                labIcon: Icons.person,
                dataKey: 'personName',
              ),
              SizedBox(height: 6.0),
              TextFieldTemplate(
                labText: "Date of Maintenance",
                hText: 'Enter the date of record',
                labIcon: Icons.date_range,
                dataKey: "dateOfMain",
              ),
              SizedBox(height: 6.0),
              TextFieldTemplate(
                labText: 'Cost of Maintenance',
                hText: "e.g. 1000",
                labIcon: Icons.attach_money,
                dataKey: 'price',
              ),
              SizedBox(height: 6.0),
              TextFieldTemplateOptional(
                labText: "Details(optional)",
                hText: "Details of repair",
                labIcon: Icons.text_snippet,
                dataKey: 'mainDesc',
              ),

              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan[900])),
                onPressed: (){
                  if (_knownFormKey.currentState.validate()){
                    _knownFormKey.currentState.save();
                    Map record = {"personName": dat['personName'], 'dateOfMain': dat['dateOfMain'],
                      'price': dat['price'], 'mainDesc': dat['mainDesc']};
                    writeToJson(record);
                  }
                },
                child: Text("Submit")
              )
            ],
          ),
        )
      ),
    );
  }
}


class TextFieldTemplate extends StatefulWidget {
  final String labText;
  final String hText;
  final IconData labIcon;
  final String dataKey;
  TextFieldTemplate({this.labText, this.hText, this.labIcon, this.dataKey});

  @override
  _TextFieldTemplateState createState() => _TextFieldTemplateState();
}

class _TextFieldTemplateState extends State<TextFieldTemplate> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText : this.widget.labText,
          icon: Icon(this.widget.labIcon),

          labelStyle: TextStyle(
              fontSize: 22.0,
             color: Colors.blueGrey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: this.widget.hText,
          hintStyle: TextStyle(
            fontSize: 20.0
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black
            ),
            gapPadding: 5.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3.5,
            ),
          ),
        ),
      validator: (String value){
          if (value.isEmpty) {
            return "Enter correct data ";
          }
          return null;
      },
      onSaved: (value){
          dat[this.widget.dataKey] = value;
      },
    );
  }
}

class TextFieldTemplateOptional extends StatefulWidget {
  final String labText;
  final String hText;
  final IconData labIcon;
  final String dataKey;
  TextFieldTemplateOptional({this.labText, this.hText, this.labIcon, this.dataKey});

  @override
  _TextFieldTemplateOptionalState createState() => _TextFieldTemplateOptionalState();
}

class _TextFieldTemplateOptionalState extends State<TextFieldTemplateOptional> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      decoration: InputDecoration(
        labelText : this.widget.labText,
        icon: Icon(this.widget.labIcon),

        labelStyle: TextStyle(
          fontSize: 22.0,
          color: Colors.blueGrey[700],
          fontWeight: FontWeight.bold,
        ),
        hintText: this.widget.hText,
        hintStyle: TextStyle(
            fontSize: 20.0
        ),

        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black
          ),
          gapPadding: 5.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 3.5,
          ),
        ),
      ),
      onSaved: (value){
        dat[this.widget.dataKey] = value;
      },
    );
  }
}
