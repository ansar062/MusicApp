import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:musik_task/Colors/colors.dart' as AppColors;
import 'package:musik_task/Services/authentication.dart';
import 'package:musik_task/Services/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Provider/dbnameprovider.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _name = TextEditingController();
  var str;
  bool isTr = false;

  DBHelper? dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: screenHeight,
          child: Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Image.asset(
                    'assets/splash.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                
                Flexible(
                  child: SizedBox(
                    height: 150,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.loveColor
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('One Good Thing About Music When it Hits You, You Feel No Pain', speed: Duration(milliseconds: 150)),
                          TypewriterAnimatedText('Music Express That Which Cannot Be Said & On Which It is Impossible to be Silent', speed: Duration(milliseconds: 150),),
                    
                        ],
                      
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Feel The Music",
                    style: TextStyle(
                      fontFamily: "Arial",
                      fontSize: 22,
                      wordSpacing: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: TextFormField(
                        controller: _name,
                        
                        onTap: () {
                          setState(() {
                            isTr = true;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Enter Your Name',
                            labelStyle: TextStyle(
                              color: AppColors.realcolor,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColors.realcolor))),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: screenWidth / 1.6,
                  height: 60,
                  
                  color: AppColors.realcolor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white70),
                  ),
                  
                  ////////////////////////////////////////////////////
                  
                  onPressed: () {
                    context.read<FirebaseAuthMethods>().singInAnonymously(context);
                  
                    setState(() {
                      str = _name.text;
                      print(str);
                  
                      dbHelper!.dbName = str.toString();
                      //Provider.of<DBNameProvider>(context, listen: false)
                      //  .setDBName(str);
                      //print(dbHelper!.dbName);
                      //dbHelper!.p();
                    });
                  }
                ),
              ],
            ),
          ),
        ),
      );
  }
}
