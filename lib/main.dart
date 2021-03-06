import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Port {
  final bool isOpen;
  final String timestamp;

  Port({@required this.isOpen, @required this.timestamp});

  String getPortStatus() {
    if(this.isOpen) {
      return "Aberta";
    } else {
      return "Fechada";
    }
  }

  Container getContainerStyle() {
    if(this.isOpen) {
      return Container(
        padding: const EdgeInsets.only(left: 200, top: 10, right: 200, bottom: 10),
        color: Colors.red,
        child: Text(getPortStatus(),
          style: new TextStyle(
            fontSize: 200.0,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 200, top: 10, right: 200, bottom: 10),
        color: Colors.green,
        child: Text(getPortStatus(),
          style: new TextStyle(
            fontSize: 200.0,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  factory Port.fromJson(Map<String, dynamic> json) {
    return Port(
      isOpen: json['isOpen'],
      timestamp: json['timestamp'],
    );
  }
}

Future<Port> fetchPort() async {
  final response = await http.get(Uri.parse('http://192.168.1.181:8000/v1/port'));
  final dynamic decodeJson = jsonDecode(response.body);
  print(decodeJson);
  return Port.fromJson(decodeJson);
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Port> futurePort;

  @override
  void initState() {
    super.initState();
    futurePort = fetchPort();
    Timer.periodic(Duration(seconds: 1), (_) => setState(() {
      futurePort = fetchPort();
    }));
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Port>(
            future: futurePort,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.getContainerStyle();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
