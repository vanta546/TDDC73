import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
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

  String _cardNumber = "";
  String _cardHolder = "";
  String _dropDownMonth = 'MM';
  String _dropDownYear = "YY";
  String _cardCVV = "";
  final String _cardTypeMaskDefault = '0000 0000 0000 0000';
  final String _cardTypeMaskAmex = '0000 000000 00000';
  final String _cardTypeMaskDiners = '0000 000000 0000';
  final FocusNode _focusNode = FocusNode();
  bool _showBackside = false;


  var cardNumberController = new MaskedTextController(mask: '0000 0000 0000 0000');
  final cardHolderController = TextEditingController();
  final cardCVVController = new MaskedTextController(mask: '0000');



  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    cardCVVController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  //CVV
  @override
  void initState(){
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus)
        setState(() {
          _showBackside = true;
        });
      else
        setState(() {
          _showBackside = false;
        });
    });
  }

  List<String> _getYearList() {
    var now = DateTime.now().year;
    List<String> yearList = new List(11);
    yearList[0] = "YY";
    for(int i = 0; i <= 9; i++) {
      String year = (now+i).toString();
      yearList[i+1] = year.substring(year.length-2);
    }
    return yearList;
  }

  void _updateCardNumber(String cardNumber) {
    //Use changeNumber as ref from CardForm.Vue
    cardNumberController.updateText(cardNumber);
    setState((){
        _cardNumber = cardNumberController.text;
    });
  }

  void _updateMask(String number){

    if (new RegExp("^3[47]\d{0,13}").hasMatch(number)) { //amex 15 digits
      cardNumberController.updateMask(_cardTypeMaskAmex);

    } else if (new RegExp("^3(?:0[0-5]|[68]\d)\d{0,11}").hasMatch(number)) { // diner's club, 14 digits
      cardNumberController.updateMask(_cardTypeMaskDiners);

    } else if (new RegExp("^\d{0,16}").hasMatch(number)) { // regular cc number, 16 digits
      cardNumberController.updateMask(_cardTypeMaskDefault);
    }
  }

  void _updateCardHolder(String cardHolder) {
    setState(() {
      _cardHolder = cardHolder;
    });
  }

  void _updateCardCVV(String cardCVV) {
    cardCVVController.updateText(cardCVV);
    setState(() {
      _cardCVV = cardCVVController.text;//cardCVV;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyCard(
              cardNumber: _cardNumber,
              cardHolder: _cardHolder,
              expireMonth: _dropDownMonth,
              expireYear: _dropDownYear,
              showBackside: _showBackside,
              cardCVV: _cardCVV,
            ),
            Container(
              width: 350,
              child:
                TextField(
                  controller: cardNumberController,
                  onChanged: (number) {
                    _updateMask(number);
                    _updateCardNumber(number);
                  },
                ),
            ),
            Container(
              width: 350,
              child:
                TextField(
                  controller: cardHolderController,
                  onChanged: (text) {
                    _updateCardHolder(text);
                  },
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right:0.0),
                  child: DropdownButton<String>(
                    value: _dropDownMonth,
                    icon: Icon(IconData(58131, fontFamily: 'MaterialIcons')),
                    items: <String>['MM','01','02', '03','04','05','06','07','08','09','10','11','12']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                        .toList(),
                    onChanged: (String newMonth) {
                      setState(() {
                        _dropDownMonth = newMonth;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: DropdownButton<String>(
                    value: _dropDownYear,
                    icon: Icon(IconData(58131, fontFamily: 'MaterialIcons')),
                    items: _getYearList()
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    onChanged: (String newYear) {
                      setState(() {
                        _dropDownYear = newYear;
                      });
                    },
                  ),
                ),

                Container(
                  width: 60,
                  child:
                    TextField(
                      controller: cardCVVController,
                      focusNode: _focusNode,
                      onChanged: (number) {
                        _updateCardCVV(number);
                      },
                    ),
                )

              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




class MyCard extends StatefulWidget {
  MyCard({Key key, this.cardNumber, this.cardHolder, this.expireMonth, this.expireYear, this.showBackside, this.cardCVV}) : super(key: key);

  final String cardNumber, cardHolder, expireMonth, expireYear, cardCVV;
  final bool showBackside;

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {

  _MyCardState() {
    _currentPlaceholder = _defaultCardPlaceholder;
    _cardNumber = _currentPlaceholder;
  }

  final String _amexCardPlaceholder = '#### ###### #####';
  final String _dinersCardPlaceholder = '#### ###### ####';
  final String _defaultCardPlaceholder = '#### #### #### ####';
  String _currentPlaceholder = "";
  String _cardNumber = "";
  String _cardType = "";
  String _cardLogo = "assets/images/visa.png";
  String _cardCVVStars = "";

  @override
  void didUpdateWidget(MyCard oldWidget) {
    if(oldWidget.cardNumber != widget.cardNumber){
      _updatePlaceHolder(_cardType);
      _updateCardType(widget.cardNumber);
      _cardNumber = _currentPlaceholder;
      _updateCardNumber();
      _updateImage();
    }

    if(oldWidget.cardCVV != widget.cardCVV) {
      _cardCVVStars = '*' * widget.cardCVV.length;
      debugPrint(widget.cardCVV);
    }
  }

  void _updateCardNumber() {
    var numberOfDigits = widget.cardNumber.length;

    var maskedCardNumber = _cardNumber.substring(numberOfDigits,_cardNumber.length);
    _cardNumber = widget.cardNumber + maskedCardNumber;
  }

  void _updatePlaceHolder(String cardType) {
    if (cardType == 'amex') {
      _currentPlaceholder = _amexCardPlaceholder;

    } else if (_cardType == 'dinersclub') {
      _currentPlaceholder = _dinersCardPlaceholder;

    } else {
      _currentPlaceholder = _defaultCardPlaceholder;
    }
  }

  void _updateCardType(cardNumber) {
    
    if(new RegExp('^4').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'visa';
      });
    }
    else if (new RegExp('^(34|37)').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'amex';
      });
    }
    else if (new RegExp('^5[1-5]').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'mastercard';
      });
    }
    else if (new RegExp('^6011').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'discover';
      });
    }
    else if (new RegExp('^62').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'unionpay';
      });
    }
    else if (new RegExp('^9792').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'troy';
      });
    }
    else if (new RegExp('^3(?:0([0-5]|9)|[689]\\d?)\\d{0,11}').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'dinersclub';
      });
    }
    else if (new RegExp('^35(2[89]|[3-8])').hasMatch(cardNumber)){
      setState(() {
        _cardType = 'jcb';
      });
    }
    else {
      setState(() {
        _cardType = "visa";
      });
    }
  }

  void _updateImage() {
    _cardLogo = "assets/images/" + _cardType + ".png";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBackside) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          image: DecorationImage(
            image: ExactAssetImage('assets/images/19.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop),
          ),
        ),
        height: 221.0,
        width: 350.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 45,
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0, right: 10.0),
                  child:
                    Text("CVV",
                    style: TextStyle(
                        fontFamily: 'Source Sans Pro', fontSize: 15),
                    ),
                    ),
                ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 330,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child:
                        Text(
                          _cardCVVStars,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'Source Sans Pro', fontSize: 20, color: Colors.black),
                        ),
                    )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10, top: 20),
                    child:
                      Image.asset(_cardLogo, height: 43),
                  ),
                ],
              ),
              ],
            ),
      );
    }
    else {
      return Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
            image: DecorationImage(
              image: ExactAssetImage('assets/images/19.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
            ),
          ),
          height: 221.0,
          width: 350.0,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child:
                    Image.asset('assets/images/chip.png', height: 43),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child:
                    Image.asset(_cardLogo, height: 43),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, top: 10.0, bottom: 28.0),
                    child:
                    Text(
                      _cardNumber,
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro', fontSize: 30),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child:
                    Text(
                      "Card Holder",
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro', fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child:
                    Text(
                      "Expires",
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro', fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child:
                    Text(
                      widget.cardHolder,
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro', fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child:
                    Text(
                      widget.expireMonth + "/" + widget.expireYear,
                      style: TextStyle(
                          fontFamily: 'Source Sans Pro', fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          )
      );
    }
  }
}