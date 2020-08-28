import 'package:coin_tracker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  // Function to create the Android style Dropdown Button
  DropdownButton<String> getDropDownButton() {
    // Create a list of dropdown items
    List<DropdownMenuItem<String>> dropdownItems = [];
    // Each dropdown item will have a value of the strings in currenciesList
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      // Add the items to the list
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      // When a different item is selected, set the value of the selectedCurrency to the selceted value, and get the new data from the API
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }
  
  // Function to create the iOS style Cupertino Picker
  CupertinoPicker getCupertinoPicker() {
    // Create a list of picker items (Text Widgets)
    List<Text> pickerItems = [];
    // Each picker item will have a value of the strings in currenciesList
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      // When a different item is selected, set the value of the selectedCurrency to the selceted value, and get the new data from the API
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }
  
  // reprsents the values of coin we get back from the Api
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  // Function that gets the currency values of each crypto
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinModel().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }
  
  // Populates the column with custom cards with the values from coinValues 
  Column makeCards() {
    List<Widget> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
          cryptoCurrency: crypto,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30),
            color: Colors.amber[600],
            child: Platform.isIOS ? getCupertinoPicker() : getDropDownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {@required this.selectedCurrency, this.value, this.cryptoCurrency});

  final String selectedCurrency;
  final String value;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Card(
        color: Colors.amber[600],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
