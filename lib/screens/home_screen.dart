import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../share_preferences/preferences.dart';

enum Operacion { sumar, restar, multiplicar, dividir }

class HomeScreen extends StatefulWidget {
  static const String routerHome = 'Home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String numberRegExp = r"^\d+\.?\d{0,6}";
  final _numero1 = TextEditingController();
  final _numero2 = TextEditingController();
  dynamic _total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora"),
        leading: IconButton(
          icon: Icon(Preferences.isDarkmode == true
            ? Icons.light_mode_outlined
            : Icons.dark_mode_outlined),
          onPressed: () {
            Preferences.isDarkmode = !Preferences.isDarkmode;
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

            Preferences.isDarkmode
              ? themeProvider.setDarkmode()
              : themeProvider.setLightmode();
            setState(() {});
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Center(
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(numberRegExp)),],
                controller: _numero1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite el primer número'),
              ),
              const SizedBox(height: 16.0,),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(numberRegExp)),],
                controller: _numero2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite el segundo número'),
              ),
              const SizedBox(height: 16.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),),
                    onPressed: () {
                      _calcular(Operacion.sumar);
                    },
                    child: const Text('+'),
                  ),
                  const SizedBox(width: 16.0,),
                  ElevatedButton(
                    style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),),
                    onPressed: () {
                      _calcular(Operacion.restar);
                    },
                    child: const Text('-'),
                  ),
                  const SizedBox(width: 16.0,),
                  ElevatedButton(
                    style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),),
                    onPressed: () {
                      _calcular(Operacion.multiplicar);
                    },
                    child: const Text('*'),
                  ),
                  const SizedBox(width: 16.0,),
                  ElevatedButton(
                    style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20),),
                    onPressed: () {
                      _calcular(Operacion.dividir);
                    },
                    child: const Text('/'),
                  ),
                ]
              ),
              const SizedBox(height: 16.0,),
              Text(
                'El total es: \n $_total',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcular(Operacion operacion) {
    if (_numero1.text.isNotEmpty && _numero2.text.isNotEmpty) {
      setState(() {
        switch (operacion) {
          case Operacion.sumar:
            double suma = double.parse(_numero1.text) + double.parse(_numero2.text);
            _setTotal(suma);
            break;
          case Operacion.restar:
            double resta = double.parse(_numero1.text) - double.parse(_numero2.text);
            _setTotal(resta);
            break;
          case Operacion.multiplicar:
            double multiplicacion = double.parse(_numero1.text) * double.parse(_numero2.text);
            _setTotal(multiplicacion);
            break;
          case Operacion.dividir:
            double division = double.parse(_numero1.text) / double.parse(_numero2.text); //! Redondear a 2 decimales;
            _setTotal(division);
            break;
        }
      });
      return;
    }

    setState(() {
      _total = "Que man tan bobo parece bobo también";
    });
  }

  void _setTotal(double result) {
    _total = result % 1 == 0 ? result.toInt() : result;
    // _total = result % 1 == 0 ? result.toInt() : result.toStringAsFixed(6);
  }
}
