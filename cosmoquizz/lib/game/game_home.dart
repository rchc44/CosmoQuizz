import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './game.dart';

// GitHub MIT license, source code: https://github.com/bluefireteam/trex-flame

/*
void main() {
  //Flame.device.fullScreen();
  runApp(
    MaterialApp(
      title: 'TRexGame',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TRexGameWrapper(),
      ),
    ),
  );
}
*/

class TRexGameWrapper extends StatefulWidget {
  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.loadAll(['sprite.png']).then(
      (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      game!.onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (game == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60),
          Center(
            child: Text(
              'Failed to Load.',
              style: TextStyle(color: Colors.red, fontSize: 25),
            ),
          ),
          SizedBox(height: 30),
          // back button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Back',
              style: TextStyle(color: Colors.blue, fontSize: 25),
            ),
          ),
        ]
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.videogame_asset),
              SizedBox(width: 15),
              Text(
                "Game",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,   // no default back arrow for going back to the previous page
        actions: [
          // game timer
          GameTimer(),
          SizedBox(width: 650),
          // end game button
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.replay),
                  SizedBox(width: 5),
                  Text(
                    "End Game",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromARGB(255, 33, 89, 243),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 60),
        ]
      ),
      body: Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: onRawKeyEvent,
          child: GameWidget(
            game: game!,
          ),
        ),
      ),
    );
  }
}

// class that return game countdown timer
class GameTimer extends StatefulWidget {
  const GameTimer({Key? key}) : super(key: key);

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  Timer? _timer;

  // set maximum time for game
  final _maxSeconds = 30;

  int _currentSecond = 0;

  // timer display format
  String get _timerFormat {
    const secondsPerMinute = 60;
    final secondsLeft = _maxSeconds - _currentSecond;

    final formattedMinutesLeft = (secondsLeft ~/ secondsPerMinute).toString().padLeft(2, '0');
    final formattedSecondsLeft = (secondsLeft % secondsPerMinute).toString().padLeft(2, '0');

    return '$formattedMinutesLeft : $formattedSecondsLeft';
  }

  void gameTimer() {
    final duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _currentSecond = timer.tick;
        // if time has passed
        if (timer.tick >= _maxSeconds) {
          timer.cancel();
          // pop-up message
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => timeOut(context),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  void initState() {
    super.initState();
    gameTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer),
          SizedBox(width: 5),
          Text(
            'Time Left: ${_timerFormat}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

// time-out message
Widget timeOut(BuildContext context) {
  return AlertDialog(
    title: Text('Time Out!', style: TextStyle(fontSize: 20)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Time to go back to work!",
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    actions: <Widget>[
      // back button
      TextButton(
        onPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
        child: Text(
          'Back to Quiz',
          style: TextStyle(
            color: Color.fromARGB(255, 33, 89, 243),
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}
