import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // static const platform = MethodChannel('samples.flutter.dev/battery');

  // String _batteryLevel = 'Unknown Battery Level';
  // Future<void> _getBatteryLevel() async {
  //   String batteryLevel;
  //   try {
  //     final int result = await platform.invokeMethod('getBatteryLevel');
  //     batteryLevel = 'Battery level at $result % . ';
  //   } on PlatformException catch (e) {
  //     batteryLevel = 'Failed to get battery level: ${e.message}';
  //   }
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _inputController = TextEditingController(text: "");
  int _counter = 0;
  static const platform = MethodChannel('samples.flutter.dev/battery');
  static const nativePlatform = MethodChannel('nativeChannel');
  // This widget is the root of your application.

  String _batteryLevel = 'Unknown Battery Level';
  int batteryResult = 50;
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      batteryResult = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $batteryResult % . ';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level: ${e.message}';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _passingMap() async {
    Map<String, dynamic> _dataMap = {
      "counter": _counter,
      'batteryLevel': batteryResult,
      'text': _inputController.text,
    };
    print('ini text flutter ${_inputController.text}');
    try {
      final String passingResult =
          await nativePlatform.invokeMethod('passing_data', _dataMap);
      print(passingResult);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passingResult),
          backgroundColor: Colors.blue,
        ),
      );
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    ;
  }

  Future<void> _counterAdd() async {
    // print('ini BcounterF $_counter');
    final int getCount =
        await platform.invokeMethod('counter', {'inputBil': _counter});
    // print('ini AcounterF $getCount');
    setState(() {
      _counter = getCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Battery Level $_batteryLevel'),
            Text('Nilai Counter $_counter'),
            ElevatedButton(
              onPressed: () {
                _getBatteryLevel();
              },
              child: const Text('Get Battery Level'),
            ),
            TextField(
              controller: _inputController,
            ),
            ElevatedButton(
              onPressed: () {
                _passingMap();
              },
              child: const Text('Passing Data'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _counterAdd,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
