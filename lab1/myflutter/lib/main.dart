import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Piff och Puff'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    image: AssetImage('assets/piffopuff.png')
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const RaisedButton(onPressed: null,
                          child: Text('Button')),
            ]
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const RaisedButton(onPressed: null,
                    child: Text('Button')),
                  ]
                ),
              ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          const RaisedButton(onPressed: null,
                              child: Text('Button')),
                      ]
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const RaisedButton(onPressed: null,
                            child: Text('Button')),
                      ]

                  ),

                ]
            ),

            Container(
              margin: EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(helperText: "Email"),
                ),
            ),
          ],
        ),
      ),
    );
  }
}