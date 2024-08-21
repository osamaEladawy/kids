import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kids_play/core/constant/responsive_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AudioPlayer players = AudioPlayer();

  Map<String, bool> score = {};
  Map<String, Color> choices = {
    '💛': Colors.yellow,
    '🍅': Colors.red,
    '🍊': Colors.orange,
    '🌺': Colors.pink,
    '🏴': Colors.black,
    '🥒': Colors.green,
    '🍆': Colors.purple,
  };
  int acceptedData = 0;

  @override
  void dispose() {
    players.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveScreenshot.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade400,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          fontStyle: FontStyle.italic,
        ),
        title: const Text('Hello Kids'),
      ),
      body: Container(
        height: ResponsiveScreenshot.screen_height,
        width: ResponsiveScreenshot.screen_width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: choices.keys.map((value) {
                  return Draggable<String>(
                    data: value,
                    feedback: Playing(value),
                    childWhenDragging: const Playing('😊'),
                    child: Playing(score[value] == true ? '👌' : value),
                  );
                }).toList()
                  ..shuffle(Random(acceptedData++))),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices.keys.map((element) {
                return buildTarget(element);
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            acceptedData++;
          });
        },
      ),
    );
  }

  Widget buildTarget(element) {
    return DragTarget<String>(
      builder: (context, inComing, rejected) {
        if (score[element] == true) {
          return Container(
            height: 80,
            width: 250,
            alignment: Alignment.center,
            color: Colors.grey[300],
            child: const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return Container(
            color: choices[element],
            height: 80,
            width: 250,
          );
        }
      },
      onWillAccept: (data) => data == element,
      onAccept: (data) {
        setState(() {
          score[element] = true;
          try {
            players.play(AssetSource('sounds/s2fa.mp3'));
          } catch (e) {
            print('Error playing sound: $e');
            return;
          }
        });
      },
      onLeave: (data) {
        if (score[element] == true) {
          score.remove(element);
        }
      },
    );
  }
}

class Playing extends StatelessWidget {
  final String emilio;
  const Playing(this.emilio, {super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: const EdgeInsets.all(15),
        child: Text(
          emilio,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
