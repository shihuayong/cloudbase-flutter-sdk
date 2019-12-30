import 'package:demo/views/test.dart';
import 'package:flutter/material.dart';
import 'package:demo/constance.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CloudBase Flutter Demo',
      theme: ThemeData(
        primarySwatch: MainMaterialColor,
      ),
      routes: {
        '/': (context) => HomePage(title: 'CloudBase Flutter Demo'),
        '/test': (context) => TestPage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  String _text = '腾讯云 - 云开发';

  _goTest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TestPage(title: 'CloudBase Flutter SDK Test')));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('logo.png'), width: 100, height: 100,),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text(
                  '$_text',
                ),
              ),
              buildButton('测试页面', _goTest),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

Widget buildButton(String text, void Function() onPressed) {
  return FlatButton(
    key: Key(text),
    color: MainColor,
    textColor: Colors.white,
    padding: EdgeInsets.all(4.0),
    splashColor: MainColor,
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(fontSize: 15.0),
    ),
  );
}
