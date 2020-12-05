import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var url = 'https://www.googleapis.com/books/v1/volumes?q={http}';

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var itemCount = jsonResponse['totalItems'];
    print('Number of books about http: $itemCount.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

String dogApiUrl = 'https://dog-api.kinduff.com/api/facts';
String catApiUrl = 'https://catfact.ninja/facts?limit=1';

String aCatFact;
String aDogFact;

class RequestFacts {
  dynamic factDog;
  dynamic factCat;

  Future<void> getDogData() async {
    var response = await http.get(dogApiUrl);
    if (response.statusCode == 200) {
      factDog = convert.jsonDecode(response.body);
      aDogFact = factDog["facts"][0];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      factDog = null;
      aDogFact = 'No Internet Available';
    }
  }

  Future<void> getCatData() async {
    var response = await http.get(catApiUrl);
    if (response.statusCode == 200) {
      factCat = convert.jsonDecode(response.body);
      aCatFact = factCat["data"][0]["fact"];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      factCat = null;
      aCatFact = 'No internet Available';
    }
  }
}
