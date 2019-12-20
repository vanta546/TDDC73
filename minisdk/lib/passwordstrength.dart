import 'package:flutter/material.dart';


class PasswordStrength extends StatefulWidget {
  PasswordStrength({Key key, this.title, this.password}) : super(key: key);

  final String title, password;

  @override
  _PasswordStrengthState createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength> {

  final strongRegex = new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
  final mediumRegex = new RegExp(r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
  final Color gray = Color(0xFFF0F0F0);
  final Color red = Color(0xFFCC3232);
  final Color yellow = Color(0xFFE7B416);
  final Color green = Color(0xFF2DC937);
  Color stepOneColor,stepTwoColor,stepThreeColor;

  init(){
    setState((){
      stepOneColor = gray;
      stepTwoColor = gray;
      stepThreeColor = gray;
    });
  }


  void calcStrength() {
    if (strongRegex.hasMatch(widget.password)) {
      stepOneColor = green;
      stepTwoColor = green;
      stepThreeColor = green;
    } else if (mediumRegex.hasMatch(widget.password)) {
      stepOneColor = yellow;
      stepTwoColor = yellow;
    } else if (widget.password != "")
      stepOneColor = red;
  }

  @override
  Widget build(BuildContext context) {
    init();
    calcStrength();
    if (widget.password == "")
      return Container();
    else {
      return Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                          color: stepOneColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0))
                      ),
                    ),
                    Container(
                      color: stepTwoColor,
                      height: 8,
                      width: 100,
                    ),
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                          color: stepThreeColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25.0),
                              bottomRight: Radius.circular(25.0))
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                  ],
                ),
            ],
          ),
      );
    }
  }
}