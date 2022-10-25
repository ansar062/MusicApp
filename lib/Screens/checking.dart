import 'package:flutter/material.dart';
import 'package:musik_task/Services/authentication.dart';
import 'package:musik_task/Services/db_helper.dart';
import 'package:musik_task/Files/audioInfo.dart';
import 'package:provider/provider.dart';

import '../Provider/filesInfoprovidder.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  DBHelper? dbHelper;
  int i = -1;
  late Future<List<AudioModel>> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    list = dbHelper!.getAudioList();
  }

  var names, paths;

  @override
  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        context.read<FirebaseAuthMethods>().deleteAccount(context);
        break;
      case 1:
        names = Provider.of<AudioFileInfoProvider>(context, listen: false)
            .nameofFile;
        paths = Provider.of<AudioFileInfoProvider>(context, listen: false)
            .pathofFile;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Delete Account'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('add'),
                      value: 1,
                    ),
                  ])
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: list,
                builder: (context, AsyncSnapshot<List<AudioModel>> snapshot) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text(snapshot.data![index].name.toString()),
                            subtitle:
                                Text(snapshot.data![index].path.toString()),
                            trailing: Text(snapshot.data![index].id.toString()),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          i++;
          dbHelper!
              .insert(AudioModel(id: i, name: names[i], path: paths[i]))
              .then((value) {
            print('data added');
            setState(() {
              list = dbHelper!.getAudioList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
      ),
    );
  }
}
