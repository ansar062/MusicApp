import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musik_task/Colors/colors.dart' as AppColors;
import 'package:musik_task/Files/audiofile.dart';
import 'package:musik_task/Provider/audiofileprovider.dart';
import 'package:musik_task/Provider/filesInfoprovidder.dart';
import 'package:musik_task/Screens/checking.dart';
import 'package:musik_task/Screens/settings.dart';
import 'package:musik_task/Services/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:musik_task/Services/authentication.dart';

import '../Files/audioInfo.dart';

class DetailAudioPage extends StatefulWidget {
  const DetailAudioPage({Key? key}) : super(key: key);

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {
  var filepath, filename, ind, file;
  bool isVisible = false;
  late bool _isLoading;
  @override
  String fileName = ' ';
  List<String> names = [];
  List paths = [];

  DBHelper? dbHelper;
  int i = -1;
  late Future<List<AudioModel>> list;

  @override
  void initState() {
    _isLoading = true;

    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  loadData() async {
    setState(() {
      Future.delayed(Duration(seconds: 3));
    });

    list = dbHelper!.getAudioList();
  }

  @override
  pickk() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        filename = result.files.single.name;
        filepath = result.files.single.path;
        Provider.of<AudioFileProvider>(context, listen: false)
            .setName(filename);
        Provider.of<AudioFileInfoProvider>(context, listen: false)
            .setNameFile(filename);
        Provider.of<AudioFileInfoProvider>(context, listen: false)
            .setPathFile(filepath);

        paths = Provider.of<AudioFileInfoProvider>(context, listen: false)
            .pathofFile;
        ind = Provider.of<AudioFileInfoProvider>(context, listen: false)
            .indexCount;

        file = paths[ind];
        Provider.of<AudioFileInfoProvider>(context, listen: false)
            .setSong(file);

        fileName =
            Provider.of<AudioFileProvider>(context, listen: false).fileName;

        names = Provider.of<AudioFileInfoProvider>(context, listen: false)
            .nameofFile;

        i++;
        isVisible = true;

        dbHelper!
            .insert(AudioModel(id: i, name: filename, path: filepath))
            .then((value) {
          print('data added');
          setState(() {
            Future.delayed(Duration(seconds: 3));
            list = dbHelper!.getAudioList();
          });
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      });
    }
  }

  @override
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        context.read<FirebaseAuthMethods>().deleteAccount(context);
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Test()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickk();
        },
        child: Icon(
          Icons.add_circle_outline_outlined,
        ),
      ),
      backgroundColor: AppColors.audioBluishbackground,
      body: Stack(children: [
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 3,
            child: Container(
              //color: AppColors.realcolor,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: ExactAssetImage("assets/12.jpg"),
                fit: BoxFit.cover,
              )),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                  ),
                ),
              ),
            )),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
            
              actions: [
                PopupMenuButton<int>(
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Delete Account'),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text('Help'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text('DSA'),
                            value: 2,
                          ),
                        ])
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            )),
        Positioned(
            left: 0,
            right: 0,
            top: screenHeight * 0.2,
            height: screenHeight * 0.33,
            //height: screenHeight * .5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.07,
                  ),
                  SizedBox(
                    height: screenHeight * 0.09,
                    child: Marquee(
                      text: fileName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.bold,
                      ),
                      blankSpace: 90,
                      velocity: 50,
                      //pauseAfterRound: Duration(seconds: 2),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  AudioFile(),
                ],
              ),
            )),
        Positioned(
            top: screenHeight * 0.12,
            left: (screenWidth - 150) / 2,
            right: (screenWidth - 150) / 2,
            height: screenHeight * 0.16,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.audioGreybackground,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/image1.png",
                        ),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            )),
        Positioned(
          left: 0,
          right: 0,
          top: screenHeight * .534,
          height: screenHeight * .464,
          child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: FutureBuilder(
                      future: list,
                      builder:
                          (context, AsyncSnapshot<List<AudioModel>> snapshot) {
                        //Future.delayed(Duration(seconds: 20));
                        var data = snapshot.data;
                        if (data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var leng = data.length;
                          if (leng == 0) {
                            return Center(
                              child: Text('No Song Added Till'),
                            );
                          }
                          else{
                            return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                          height: 70,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 350,
                                child: Marquee(
                                  text: snapshot.data![index].name.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  blankSpace: 90,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        );
                            });
                          }
                        }
                        
                      }),
                ),
        ),
        
      ]),
    );
    // ignore: dead_code
  }
}



// Card(
//                                 child: ListTile(
//                                   contentPadding: EdgeInsets.all(8),
//                                   title: Text(
//                                       snapshot.data![index].name.toString()),
//                                   subtitle: Text(
//                                       snapshot.data![index].path.toString()),
//                                   trailing:
//                                       Text(snapshot.data![index].id.toString()),
//                                 ),
//                               );














