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
  List<double> imcList = <double>[];

  Future<void> addImc(String h, String w) async {
    var height = double.tryParse(h);
    var weight = double.tryParse(w);
    await imcRepo.addImc(ImcModel(height!, weight!));
    imcList = await imcRepo.getImcs();
    setState(() {});
  }

  Future<void> getImcs() async {
    imcList = await imcRepo.getImcs();
  }

  Widget checkImcValue(double imc) {
    return Container(
        child: imc < 16
            ? const Text('Magreza grave')
            : 16 < imc && imc < 17
                ? const Text('Magreza moderada')
                : 17 < imc && imc < 18.5
                    ? const Text('Magreza leve')
                    : 18.5 < imc && imc < 25
                        ? const Text('Saudável')
                        : 25 < imc && imc < 30
                            ? const Text('Sobrepeso')
                            : 30 < imc && imc < 35
                                ? const Text('Obesidade grau I')
                                : 35 < imc && imc < 40
                                    ? const Text('Obresidade grau II (severa)')
                                    : const Text(
                                        'Obesidade grau III (mórbida)'));
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
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter.allow(r'/^[0-9]+.[0-9]+$'),
              // ],
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                  hintText: 'Digite seu peso',
                  prefixIcon: Icon(Icons.keyboard_alt_outlined)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
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
                    imc.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: checkImcValue(imc),
                );
              }).toList()),
            )
          ],
        ),
      ),
    );
  }
}
