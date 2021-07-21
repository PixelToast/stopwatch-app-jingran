import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch App',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  static const String keyStart = "start";
  static const String keyLaps = "laps";

  static const String initialTimerText = "00:00.0";
  final _timerFormat = DateFormat("mm:ss.S");
  late final SharedPreferences _sharedPreferences;

  Timer? _timer;
  late DateTime _startTime;
  late DateTime _elapsed;
  String _timerText = initialTimerText;

  List<String> _laps = [];

  @override
  void initState() {
    super.initState();
    setUpSharedPreferences();
  }

  setUpSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    int startTime = _sharedPreferences.getInt(keyStart) ?? 0;
    if (0 != startTime) {
      _startTime = Clock(
            () => DateTime.fromMillisecondsSinceEpoch(startTime),
      ).now();
      print(_startTime);
      updateElapsed();
    }

    List<String> laps = _sharedPreferences.getStringList(keyLaps) ?? [];
    if( laps.isNotEmpty ) {
      _laps = laps;
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  start() {
    stop();
    _laps.clear();
    _sharedPreferences.remove(keyLaps);
    _startTime = clock.now();
    _sharedPreferences.setInt(keyStart, _startTime.millisecondsSinceEpoch);
    updateElapsed();
  }

  updateElapsed() async {
    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      (timer) {
        _elapsed = clock.now().subtract(
            Duration(milliseconds: _startTime.millisecondsSinceEpoch));
        String timerText = _timerFormat.format(_elapsed);
        //remove last two characters to simulate tenths
        timerText = timerText.substring(0, timerText.length - 2);
        setState(() {
          _timerText = timerText;
        });
      },
    );
  }

  stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  stop() {
    stopTimer();
    _sharedPreferences.remove(keyStart);
    setState(() {
      _timerText = initialTimerText;
    });
  }

  lap() {
    setState(() {
      _laps.add(_timerText);
    });
    _sharedPreferences.setStringList(keyLaps, _laps);
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
                key: Key('timer.display'),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                key: Key("start.button"),
                onPressed: () => start(),
                child: Text("Start"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                key: Key("stop.button"),
                onPressed: () => stop(),
                child: Text("Stop"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                key: Key("lap.button"),
                onPressed: null == _timer ? null : () => lap(),
                child: Text("Lap"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  int reversedIndex = _laps.length - index - 1;
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Lap ${reversedIndex + 1}: ${_laps[reversedIndex]}",
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
