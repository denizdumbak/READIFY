import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readify/models/bookmodel.dart';

Future searchBooks({required String searchWord}) async {
  final response = await http.get(Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=${searchWord}&maxResults=40'));
  if (response.statusCode == 200) {
    String jsonResponse = response.body;
    Map<String, dynamic> data = json.decode(jsonResponse);

    return data;
  } else {
    print('API isteği başarısız oldu: ${response.statusCode}');
    throw 'hata';
  }
}
