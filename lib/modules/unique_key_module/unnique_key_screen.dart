import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:criptografei/home/initial_screen.dart';
import 'package:flutter/services.dart';

class XorCipherController {
  static Map<String, dynamic> encrypt(String message) {
    if (message.isEmpty) {
      throw ArgumentError("A mensagem não pode estar vazia");
    }

    final key = _generateRandomKey(message.length);
    final messageBytes = utf8.encode(message);
    final keyBytes = utf8.encode(key);

    final encryptedBytes = List<int>.generate(
      messageBytes.length,
      (i) => messageBytes[i] ^ keyBytes[i],
    );

    return {
      'key': key,
      'encrypted': encryptedBytes,
      'binary': _bytesToBinary(encryptedBytes),
      'hex': _bytesToHex(encryptedBytes),
    };
  }

  static String decryptFromBinary(String binary, String key) {
    if (binary.isEmpty || key.isEmpty) {
      throw ArgumentError("Binário e chave não podem estar vazios");
    }

    final bytes = _binaryToBytes(binary);
    final keyBytes = utf8.encode(key);

    if (bytes.length != keyBytes.length) {
      throw ArgumentError(
          "A chave deve ter o mesmo tamanho da mensagem original");
    }

    final decryptedBytes = List<int>.generate(
      bytes.length,
      (i) => bytes[i] ^ keyBytes[i],
    );

    return utf8.decode(decryptedBytes);
  }

  static String _generateRandomKey(int length) {
    final random = Random.secure();
    return String.fromCharCodes(
      List.generate(length, (_) => random.nextInt(26) + 65), // A-Z
    );
  }

  static String _bytesToBinary(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(2).padLeft(8, '0')).join(' ');
  }

  static List<int> _binaryToBytes(String binary) {
    return binary.split(' ').map((b) => int.parse(b, radix: 2)).toList();
  }

  static String _bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

class UniqueKeyCipherScreen extends StatefulWidget {
  const UniqueKeyCipherScreen({super.key});

  @override
  State<UniqueKeyCipherScreen> createState() => _UniqueKeyCipherScreenState();
}

class _UniqueKeyCipherScreenState extends State<UniqueKeyCipherScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputBinaryController = TextEditingController();
  final TextEditingController _outputKeyController = TextEditingController();
  final TextEditingController _decryptKeyController = TextEditingController();
  final TextEditingController _decryptBinaryController =
      TextEditingController();
  final TextEditingController _decryptedTextController =
      TextEditingController();

  void _criptografar() {
    try {
      final texto = _inputController.text;
      final resultado = XorCipherController.encrypt(texto);

      setState(() {
        _outputKeyController.text = resultado['key'];
        _outputBinaryController.text = resultado['binary'];
      });
    } catch (e) {
      _showSnackBar('Erro ao criptografar: ${e.toString()}');
    }
  }

  void _descriptografar() {
    try {
      final decrypted = XorCipherController.decryptFromBinary(
        _decryptBinaryController.text,
        _decryptKeyController.text,
      );

      setState(() {
        _decryptedTextController.text = decrypted;
      });
    } catch (e) {
      _showSnackBar('Erro ao descriptografar: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Criptografia XOR Binária',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InitialScreen()),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Seção de Criptografia
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'CRIPTOGRAFAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        labelText: 'Texto original',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _criptografar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('CRIPTOGRAFAR'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _outputKeyController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Chave gerada',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(
                            _outputKeyController.text,
                            'Chave copiada!',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _outputBinaryController,
                            readOnly: true,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Binário cifrado',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyToClipboard(
                            _outputBinaryController.text,
                            'Binário copiado!',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Seção de Descriptografia
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'DESCRIPTOGRAFAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _decryptKeyController,
                      decoration: const InputDecoration(
                        labelText: 'Cole a chave aqui',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _decryptBinaryController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Cole o binário aqui',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _descriptografar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('DESCRIPTOGRAFAR'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _decryptedTextController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Texto descriptografado',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
