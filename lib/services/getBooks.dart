import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readify/models/bookmodel.dart';


Future getBooks() async {
  final response = await http.get(Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=world+classics&maxResults=40'));
  if (response.statusCode == 200) {
    String jsonResponse = response.body;
    Map<String, dynamic> data = json.decode(jsonResponse);

    return data;
  } else {
    print('API isteği başarısız oldu: ${response.statusCode}');
    throw 'hata';
  }
}
