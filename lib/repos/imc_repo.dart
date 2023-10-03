import 'dart:math';

import 'package:imc_flutter/classes/imc_model.dart';

class ImcListRepo {
  final List<double> _imcs = [];

  Future<List<double>> getImcs() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _imcs;
  }

  Future<void> addImc(ImcModel values) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var imc = (values.weight / (pow(values.height, 2)));
    _imcs.add(imc);
  }
}
