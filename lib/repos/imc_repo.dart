import 'dart:math';

import 'package:imc_flutter/classes/imc_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcListRepo {
  final List<double> _imcs = [];
  late SharedPreferences storage;
  String keyImc = 'imcKey';

  Future<List<double>> getImcs() async {
    storage = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 100));
    return _imcs;
  }

  Future<void> addImc(ImcModel values) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var imc = (values.weight / (pow(values.height, 2)));
    _imcs.add(imc);
  }

  Future<void> saveImcList(List<String> list) async {
    storage = await SharedPreferences.getInstance();
    storage.setStringList(keyImc, list);
  }

  Future<List<String>> getImcList() async {
    storage = await SharedPreferences.getInstance();
    return storage.getStringList(keyImc) ?? [];
  }
}
