import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readify/models/bookmodel.dart';


Future getBookInfo({required String id}) async {
  final response = await http
      .get(Uri.parse('https://www.googleapis.com/books/v1/volumes/$id'));
  if (response.statusCode == 200) {
    String jsonResponse = response.body;
    Map<String, dynamic> data = json.decode(jsonResponse);

    return data;
  } else {
    print('API isteği başarısız oldu: ${response.statusCode}');
    throw 'hata';
  }
}
