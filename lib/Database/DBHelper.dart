import 'dart:async';
import 'dart:io';

import 'package:fluttercrudsqlite/Model/Contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static String TABLE_NAME="contacts";
  static Database dbInstance;

  Future<Database> get db async{
    if(dbInstance == null)
      dbInstance = await initDB();
    return dbInstance;
  }

  initDB() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'gzeinumer.db';
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  FutureOr<void> onCreateFunc(Database db, int version) async{
    await db.execute("CREATE TABLE $TABLE_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,phone TEXT);");
  }

  Future<List<Contact>> getContacts() async{
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery('SELECT * FROM $TABLE_NAME;');
    List<Contact> contacts = new List();
    for(int i = 0; i<list.length; i++){
      Contact c = new Contact.constructor();
      c.id = list[i]['id'];
      c.name = list[i]['name'];
      c.phone = list[i]['phone'];

      contacts.add(c);
    }
    return contacts;
  }

  void addNewData(Contact c) async{
    var dbConnection = await db;
    String query = 'INSERT INTO $TABLE_NAME(name, phone) VALUES(\'${c.name}\',\'${c.phone}\');';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  void updateData(Contact c) async{
    var dbConnection = await db;
    String query = 'UPDATE $TABLE_NAME SET name=\'${c.name}\' phone=\'${c.phone}\' WHERE id=\'${c.id}\';';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  void deleteData(Contact c) async{
    var dbConnection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE id=\'${c.id}\';';
    await dbConnection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }
}