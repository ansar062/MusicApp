import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musik_task/Files/audioInfo.dart';
import 'package:musik_task/Screens/loginScreen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import '../Provider/dbnameprovider.dart';

class DBHelper {
  static Database? _db;
  var dbName;
  var ansar;

  void p() {
    print("HELPER NAME");
    print(dbName);

    ansar = dbName;
  }

  Future<Database?> get db async {
    if (_db == null) {
      print(ansar);
      _db = await initDatabase();
      return _db;
    }
    //_db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    //print("${ansar}HEllo");
    String path = join(documentDirectory.path, 'realdata.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE addsong (
          id INTEGER NOT NULL,
          name TEXT NOT NULL,
          path TEXT NOT NULL
        )
      ''');
  }

  Future<AudioModel> insert(AudioModel audioModel) async {
    var dbClient = await db;

    await dbClient!.insert('addsong', audioModel.toMap());
    return audioModel;
  }

  Future<List<AudioModel>> getAudioList() async {
    
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('addsong');

    return queryResult.map((e) => AudioModel.fromMap(e)).toList();
  }
}

// build(BuildContext context) async {
//   var dbName;
//   dbName = Provider.of<DBNameProvider>(context, listen: false).dbName;
//   print(dbName);
// }

