import 'package:flutter/material.dart';
import 'package:minisdk/registerform.dart';
import 'package:flutter/services.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

// => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'DOGBUDDY'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String _image = "images/dog.png";
  final Color _buttonColor = new Color(0xFF6200EE);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Registerform(
          image: _image,
          title: widget.title,
          buttonColor: _buttonColor,
          callback: (formInfo) => {
            for(int i = 0; i < formInfo.length; i++){
              debugPrint(formInfo.elementAt(i))
            }
          },
          fieldTypes: ["Firstname", "Color", "Phone number", "Password"],
        ),
      ),
    );
  }
}
