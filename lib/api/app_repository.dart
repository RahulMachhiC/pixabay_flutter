import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:interview/api/api_base_helper.dart';

class AppRepository {
  ApiBaseHelper helper = ApiBaseHelper();

  Future<dynamic> fetchimages() async {
    final response = await helper.get(
      "key=23325136-efdb262febd8a9916828623a9&per_page=200",
    );

    return response;
  }

  Future<dynamic> fetchSearchimages({required String query}) async {
    final response = await helper.get(
      "key=23325136-efdb262febd8a9916828623a9&q=$query&per_page=200",
    );

    print(response);

    return response;
  }
}
