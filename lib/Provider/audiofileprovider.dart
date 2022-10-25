import 'package:flutter/material.dart';

class AudioFileProvider extends ChangeNotifier {
  String fileName = '';
  String filePath = '';
  AudioFileProvider({
    this.fileName = '',
    this.filePath = '',
  });

  void setName(String f_name) {
    fileName = f_name;
    notifyListeners();
  }
}
