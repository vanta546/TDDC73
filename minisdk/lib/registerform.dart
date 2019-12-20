import 'package:flutter/material.dart';
import 'package:minisdk/passwordstrength.dart';

typedef void StringCallback(List<String> formInfo);

class Registerform extends StatefulWidget {
  Registerform({Key key, this.title, this.image, this.buttonColor, this.callback, this.fieldTypes}) : super(key: key);

  final String title, image;
  final Color buttonColor;
  final StringCallback callback;
  final List<String> fieldTypes;

  @override
  _RegisterformState createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {

  //Grouping the fields
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  List<String> formInfo = [];

  List<Widget> loadFields() {

    List<Widget> result = [];

    for (int i = 0; i < widget.fieldTypes.length; i++){
      if (widget.fieldTypes.elementAt(i) == "Password") {
        result.add(RegisterformField(
            fieldType: widget.fieldTypes.elementAt(i),
            controller: passwordController,
            callback: (value) => {formInfo.add(value)}
        ));
      } else {
        result.add(RegisterformField(
            fieldType: widget.fieldTypes.elementAt(i),
            controller: new TextEditingController(),
            callback: (value) => {formInfo.add(value)}
        ));
      }

    }

    return result;
  }

  List<Widget> fields = [];

  @override
  void initState() {
    fields = loadFields();
    fields.add(
      Container(
        margin: EdgeInsets.only(top: 40, bottom: 80),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              blurRadius: 10,
            ),
          ],
        ),
        child:
        ConstrainedBox(
          constraints: BoxConstraints(minWidth:  double.infinity),
          child:
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            color: widget.buttonColor,
            padding: const EdgeInsets.all(0.0),
            textColor: Colors.white,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.callback(formInfo);
              }
            },
            child: Center(
              child:Text(
                "Register",
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
        ),
      ),
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: ListView(
        reverse: true,
        children:<Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
            child:
                Center(
                  child:
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ),
          Image(
            image: AssetImage(widget.image),
            height: 140,
          ),
          Form(
            key: _formKey,
            child:
              Padding(
                padding: EdgeInsets.only(left: 40.0, right: 40.0),
                child:
                Column(
                  children: fields,
                ),
              ),
          ),
        ].reversed.toList(),
      ),
    );
  }
}


typedef void ValueCallback(String value);

class RegisterformField extends StatefulWidget {
  RegisterformField({Key key, this.controller, this.fieldType, this.callback}) : super(key: key);

  final TextEditingController controller;
  final String fieldType;
  final ValueCallback callback;

  @override
  _RegisterformFieldState createState() => _RegisterformFieldState();
}

class _RegisterformFieldState extends State<RegisterformField> {

  var validator;
  final RegExp emailCheck = new RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  final RegExp phoneNumbCheck = new RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$");
  String _password = "";

  void setValidator(){
    switch(widget.fieldType) {
      case "Firstname": {
        validator = (value) {
          if (value.isEmpty) {
            return 'Firstname is empty!';
          }
          return null;
        };
      }
      break;
      case "Surname": {
        validator = (value) {
          if (value.isEmpty) {
            return 'Surname is empty!';
          }
          return null;
        };
      }
      break;
      case "Email": {
        validator = (value) {
          if (value.isEmpty) {
            return 'Email is empty!';
          }
          else if(!emailCheck.hasMatch(value))
            return "Wrong email adress!";
          return null;
        };
      }
      break;
      case "Phone number": {
        validator = (value) {
          if (value.isEmpty) {
            return 'Email is empty!';
          }
          else if(!phoneNumbCheck.hasMatch(value))
            return "Wrong phone number!";
          return null;
        };
      }
      break;
      case "Password": {
        validator = (value) {
          if (value.isEmpty) {
            return 'Password is empty!';
          } else if (value.length < 8)
            return 'Password needs at least 8 characters';
          return null;
        };
      }
      break;
      default: {
        validator = (value) {
          if (value.isEmpty) {
            return 'This field is empty!';
          }
          return null;
        };
      }
      break;
    }
  }

  @override
  void initState() {
    setValidator();
    super.initState();
  }

  Widget showPasswordStrengthMeter() {
    if (widget.fieldType == "Password") {
      return PasswordStrength(
          password: _password,
      );
    } else return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          child:
          TextFormField(
            obscureText: widget.fieldType == "Password" ? true : false,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.fieldType,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              hintStyle: TextStyle(color: Color(0xFF5D5D5D)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none
                  )
              ),
              fillColor: Color(0xFFF0F0F0),
              filled: true,
            ),
            onChanged: (text) {
              if (widget.fieldType == "Password") {
                setState(() {
                  _password = widget.controller.text;
                });
              }
            },
            validator: validator,
            onSaved: (value) {
              widget.callback(value);
            },
          ),
        ),
        showPasswordStrengthMeter(),
      ],
    );
  }
}


