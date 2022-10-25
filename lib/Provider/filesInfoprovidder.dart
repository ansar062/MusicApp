import 'package:flutter/material.dart';

class AudioFileInfoProvider extends ChangeNotifier {
  List<String> nameofFile = [];
  List<dynamic> pathofFile = [];
  dynamic songtoplay;
  int get countname => nameofFile.length;
  int get countpath => pathofFile.length;
  List<String> get cartname => nameofFile;
  List<dynamic> get cartpath => pathofFile;
  int indexCount = -1;

  void setNameFile(String f_name) {
    nameofFile.add(f_name);
    increaseindex();
    notifyListeners();
  }

  void setPathFile(dynamic f_path) {
    pathofFile.add(f_path);
    notifyListeners();
  }

  int getLength() {
    return countname;
  }

  void setSong(dynamic song) {
    songtoplay = song;
  }

  void increaseindex() {
    indexCount++;
  }
}
