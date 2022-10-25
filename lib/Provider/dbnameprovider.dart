import 'package:flutter/material.dart';

class DBNameProvider extends ChangeNotifier {
  String dbName = '';

  DBNameProvider({
    this.dbName = '',
  });

  void setDBName(String f_name) {
    dbName = f_name;
    notifyListeners();
  }
}
