import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrudsqlite/Database/DBHelper.dart';
import 'package:fluttercrudsqlite/Model/Contact.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MyContactsList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact contact = new Contact.constructor();
  String name, phone;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text('Create Contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.view_list),
            tooltip: "View List",
            onPressed: () {
              startContactsList();
            },
          )
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: "name",
                ),
                validator: (val) => val.length == 0 ? "Enter your name" : null,
                onSaved: (val) => this.name = val,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: "phone"),
                validator: (val) => val.length == 0 ? "Enter your phone" : null,
                onSaved: (val) => this.phone = val,
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10),
                child: new RaisedButton(
                  onPressed: submitContact,
                  child: Text("Add new Contact zein"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitContact() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return null;
    }
    var contact = new Contact.constructor();
    contact.name = name;
    contact.phone = phone;

    var dbHelper = DBHelper();
    dbHelper.addNewData(contact);
    Fluttertoast.showToast(
        msg: 'Contact was inserted',
        toastLength: Toast.LENGTH_SHORT
    );
  }

  void startContactsList() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new MyContactsList()));
  }
}
