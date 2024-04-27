import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:interview/api/app_exceptions.dart';

class ApiBaseHelper {
  final String _baseUrl = "https://pixabay.com/api/?";
  Future<dynamic> get(
    String url,
  ) async {
    debugPrint('Api Get, url $url');
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(
          _baseUrl + url,
        ),
      );
      responseJson = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    }
    debugPrint(
      'api get recieved!',
    );
    return responseJson;
  }

  Future<dynamic> post(
    String url,
    dynamic body,
    Map<String, String>? headers,
  ) async {
    debugPrint(
      'Api Post, url ${_baseUrl + url}',
    );

    debugPrint(body.toString());
    dynamic responseJson;
    try {
      final response = await http.post(
          Uri.parse(
            _baseUrl + url,
          ),
          body: body,
          headers: headers);
      debugPrint(response.body);
      responseJson = _returnResponse(
        response,
      );
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(
        message: 'No Internet connection',
      );
    }
    debugPrint(
      'api post. $url',
    );
    return responseJson;
  }
}

dynamic _returnResponse(
  http.Response response,
) {
  switch (response.statusCode) {
    case 200:
      return json.decode(
        response.body.toString(),
      );

    case 400:
      var responseJson = json.decode(
        response.body.toString(),
      );
      return responseJson;
    case 401:
    case 403:
      throw UnauthorisedException(
        response.body.toString(),
      );
    case 500:
    case 201:
      var responseJson = json.decode(
        response.body.toString(),
      );
      return responseJson;
    default:
      throw FetchDataException(
        message:
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
      );
  }
}
