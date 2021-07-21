import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stopwatch App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String initialTimerText = "00:00.0";
  final _timerFormat = DateFormat("mm:ss.S");

  Timer? _timer;
  late DateTime _startTime;
  late DateTime _elapsed;
  String _timerText = initialTimerText;

  start() {
    stop();
    _startTime = DateTime.now();
    updateElapsed();
  }

  updateElapsed() async {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _elapsed = DateTime.now().subtract(Duration(
        milliseconds: _startTime.millisecondsSinceEpoch,
      ));
      String timerText = _timerFormat.format(_elapsed);
      //remove last two characters to simulate tenths
      timerText = timerText.substring(0, timerText.length - 2);
      setState(() {
        _timerText = timerText;
      });
    });
  }

  stop() {
    _timer?.cancel();
    setState(() {
      _timerText = initialTimerText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$_timerText',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => start(),
                child: Text("Start"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => stop(),
                child: Text("Stop"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
