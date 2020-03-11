import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrudsqlite/Database/DBHelper.dart';
import 'package:fluttercrudsqlite/Model/Contact.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<List<Contact>> getContactFromDB() async{
  var dbHelper = DBHelper();
  Future<List<Contact>> contacts = dbHelper.getContacts();
  return contacts;
}

class MyContactsList extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new _MyContactsListState();
}

class _MyContactsListState extends State<MyContactsList>{

  final controllerName = new TextEditingController();
  final controllerPhone = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
          future: getContactFromDB(),
          builder: (context, snapshot){
            if(snapshot.data !=null){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return new Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Text(
                                snapshot.data[index].phone,
                                style: TextStyle(
                                  color: Colors.grey[500]
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (_)=> new AlertDialog(
                                contentPadding: const EdgeInsets.all(16.0),
                                content: new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          TextFormField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: snapshot.data[index].name
                                            ),
                                            controller: controllerName,
                                          ),
                                          TextFormField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                hintText: snapshot.data[index].phone
                                            ),
                                            controller: controllerPhone,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')
                                  ),
                                  new FlatButton(
                                      onPressed: (){
                                        var dbHelper = DBHelper();
                                        Contact contact = new Contact.constructor();
                                        contact.id = snapshot.data[index].id;
                                        //if name empty, keep old value
                                        contact.name = controllerName.text != '' ? controllerName.text: snapshot.data[index].name;
                                        contact.phone = controllerPhone.text != '' ? controllerPhone.text: snapshot.data[index].phone;
                                        dbHelper.updateData(contact);
                                        Navigator.pop(context);
                                        setState(() {
                                          getContactFromDB(); //refresh data
                                        });

                                        Fluttertoast.showToast(
                                            msg: 'Contact was update',
                                            toastLength: Toast.LENGTH_SHORT
                                        );
                                      },
                                      child: Text('Update')
                                  )
                                ],
                              )
                            );
                          },
                          child: Icon(
                            Icons.update,
                            color: Colors.red
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            var dbHelper = new DBHelper();
                            dbHelper.deleteData(snapshot.data[index]);

                            setState(() {
                              getContactFromDB(); //refresh data
                            });
                            Fluttertoast.showToast(
                                msg: 'Contact was delete',
                                toastLength: Toast.LENGTH_SHORT
                            );
                          },
                          child: Icon(
                              Icons.delete,
                              color: Colors.red
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            } else if(snapshot.data.length == 0){
              return Text('No data found');
            }
            return Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }

}