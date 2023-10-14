import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imc_flutter/classes/imc_model.dart';
import 'package:imc_flutter/repos/imc_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  ImcListRepo imcRepo = ImcListRepo();
  List<String> imcList = <String>[];

  Future<void> addImc(String h, String w) async {
    try {
      var height = double.parse(h);
      var weight = double.parse(w);
      var calculate = (weight / (pow(height, 2)));
      imcList.add(calculate.toString());
      await imcRepo.saveImcList(imcList);
      imcList = await imcRepo.getImcList();
      setState(() {});
    } catch (e) {
      myDialog();
      return;
    }
  }

  Future<void> getImcs() async {
    imcList = await imcRepo.getImcList();
    setState(() {});
  }

  String checkImcValue(double imc) {
    if (imc < 16) return 'Magreza grave';
    if (16 < imc && imc < 17) return 'Magreza moderada';
    if (17 < imc && imc < 18.5) return 'Magreza leve';
    if (18.5 < imc && imc < 25) return 'Saudável';
    if (25 < imc && imc < 30) return 'Sobrepreso';
    if (30 < imc && imc < 35) return 'Obesidade grau I';
    if (35 < imc && imc < 40) return 'Obresidade grau II (severa)';
    return 'Obesidade grau III (mórbida)';
  }

  MaterialColor checkImcForColor(double imc) {
    if (imc < 16) return Colors.red;
    if (16 < imc && imc < 17) return Colors.pink;
    if (17 < imc && imc < 18.5) return Colors.pink;
    if (18.5 < imc && imc < 25) return Colors.green;
    if (25 < imc && imc < 30) return Colors.pink;
    if (30 < imc && imc < 35) return Colors.red;
    if (35 < imc && imc < 40) return Colors.red;
    return Colors.red;
  }

  void _close() {
    Navigator.pop(context);
  }

  Future<dynamic> myDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: const Text('Erro'),
              content: const Text('Favor informar valores válidos'),
              actions: [
                InkWell(
                    onTap: () {
                      _close();
                    },
                    child: const Text('Fechar'))
              ]);
        });
  }

  @override
  void initState() {
    super.initState();
    getImcs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IMC App',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Digite sua altura',
                  prefixIcon: Icon(Icons.keyboard_alt_outlined)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Digite seu peso',
                  prefixIcon: Icon(Icons.keyboard_alt_outlined)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
                print(imcList);
                addImc(heightController.text, weightController.text);
                heightController.text = '';
                weightController.text = '';
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
              child: const Text(
                'Calcular IMC',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView(
                  children: imcList.map((imc) {
                return ListTile(
                  title: Text(
                    imc,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    checkImcValue(double.parse(imc)),
                    style:
                        TextStyle(color: checkImcForColor(double.parse(imc))),
                  ),
                );
              }).toList()),
            )
          ],
        ),
      ),
    );
  }
}
