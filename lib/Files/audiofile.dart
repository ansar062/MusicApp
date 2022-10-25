
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musik_task/Provider/audiofileprovider.dart';
import 'package:musik_task/Provider/filesInfoprovidder.dart';
import 'package:provider/provider.dart';
import 'package:musik_task/Colors/colors.dart' as AppColors;

class AudioFile extends StatefulWidget {
  const AudioFile({super.key});

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  var currentFileName, currentFilePath;
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isRepeat = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Color colorRepeat = Colors.grey;
  Color colorLoop = Colors.grey;

  @override
  void initState() {
    super.initState();
    setAudio();

    player.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration(seconds: 0);

        if (isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
        }
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future setAudio() async {
    player.setReleaseMode(ReleaseMode.loop);
    player.setSourceDeviceFile(currentFilePath);
  }

  var ind;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void changetoSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    player.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    String fileName = Provider.of<AudioFileProvider>(context).fileName;
    dynamic file =
        Provider.of<AudioFileInfoProvider>(context, listen: false).songtoplay;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      //height: screenWidth / 3,
      //width: screenWidth / 1.2,
      //color: Colors.yellow,
      child: Column(children: [
        Slider(
          activeColor: AppColors.realcolor,
          inactiveColor: Colors.grey,
          value: position.inSeconds.toDouble(),
          min: 0.0,
          max: duration.inSeconds.toDouble()+1,
          onChanged: (double value) {
            setState(() {
              changetoSecond(value.toInt());
              value = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(position)),
              Text(formatTime(duration - position)),
            ],
          ),
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.loop,
                ),
                iconSize: 30,
                color: colorRepeat,
                onPressed: () {
                  if (isRepeat == false) {
                    player.setReleaseMode(ReleaseMode.loop);
                    setState(() {
                      isRepeat = true;
                      colorRepeat = AppColors.realcolor;
                    });
                  } else if (isRepeat == true) {
                    player.setReleaseMode(ReleaseMode.release);
                    setState(() {
                      isRepeat = false;
                      colorRepeat = Colors.grey;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_rewind_rounded,
                ),
                iconSize: 35,
                color: Colors.grey,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                ),
                iconSize: 35,
                color: AppColors.realcolor,
                onPressed: () async {
                  if (isPlaying) {
                    await player.pause();
                  } else {
                    await player.play(DeviceFileSource(file));
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_forward_rounded,
                ),
                iconSize: 35,
                color: Colors.grey,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.repeat,
                ),
                iconSize: 30,
                color: colorLoop,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
