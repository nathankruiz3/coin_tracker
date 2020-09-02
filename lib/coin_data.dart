import 'package:coin_tracker/networking.dart';

const apiKey = '0';

class CoinModel {
  
  // Function to get the current value of a selected currency from the CoinAPI
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey';
      NetworkHelper helper = NetworkHelper(requestURL);
      var decodedData = await helper.getData();
      double price = decodedData['rate'];
      cryptoPrices[crypto] = price.toStringAsFixed(2);
    }
    return cryptoPrices;
  }
}

// List of Strings to repesent the currency types in the DropdownButton and CupertinoPicker
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

// List of Strings to represent the crypto values 
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
