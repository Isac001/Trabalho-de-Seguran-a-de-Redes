import 'package:criptografei/home/initial_screen.dart';
import 'package:criptografei/modules/transposition_module/transposition_controller.dart';
import 'package:flutter/material.dart';

class TranspositionScreen extends StatefulWidget {
  const TranspositionScreen({super.key});

  @override
  State<TranspositionScreen> createState() => _TranspositionScreenState();
}

class _TranspositionScreenState extends State<TranspositionScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  final TranspositionController _controller = TranspositionController();

  void _criptografar() {
    final texto = _inputController.text;
    final chave = _keyController.text;

    if (chave.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite uma chave válida!')),
      );
      return;
    }

    final resultado = _controller.criptografar(texto, chave);

    setState(() {
      _outputController.text = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cifra de Transposição',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InitialScreen()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Digite o texto',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: 'Digite a chave (ex: SEGREDO)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _criptografar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: Text(
                  'Criptografar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _outputController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Texto criptografado',
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
