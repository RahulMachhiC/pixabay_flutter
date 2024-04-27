import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:interview/api/app_repository.dart';
import 'package:interview/model/pixabsyresponse.dart';

class HomeController extends ChangeNotifier {
  PixabayResponse hit = PixabayResponse();
  bool isloading = false;
  bool iserror = false;
  String errortext = '';

  TextEditingController searchController = TextEditingController();

  void fetchdata({
    required BuildContext context,
  }) async {
    isloading = true;
    notifyListeners();

    try {
      await AppRepository().fetchimages().then((value) {
        isloading = false;

        hit = PixabayResponse.fromJson(value);
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      iserror = true;
      isloading = false;

      notifyListeners();
    } finally {
      // pageSize++;
      // notifyListeners();
    }
    notifyListeners();
  }

  void clearsearch({required BuildContext context}) {
    searchController.clear();
    fetchdata(context: context);
    notifyListeners();
  }

  void fetchSearchdata({
    required BuildContext context,
    required String value,
  }) async {
    isloading = true;
    hit = PixabayResponse();
    // hit.clear();
    notifyListeners();

    try {
      await AppRepository().fetchSearchimages(query: value).then((value) {
        isloading = false;

        notifyListeners();

        hit = PixabayResponse.fromJson(value);
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      iserror = true;
      isloading = false;

      notifyListeners();
    } finally {
      // pageSize++;
      // notifyListeners();
    }
    notifyListeners();
  }
}
