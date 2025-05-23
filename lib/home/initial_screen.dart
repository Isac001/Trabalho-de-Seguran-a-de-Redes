// Importações dos componentes e telas necessárias para o app
import 'package:criptografei/components/bottom_bar_component.dart';
import 'package:criptografei/modules/caesar_cipher_module/ceaser_cipher_screen.dart';
import 'package:criptografei/modules/unique_key_module/unnique_key_screen.dart';
import 'package:criptografei/modules/transposition_module/transposition_screen.dart';
import 'package:flutter/material.dart';

// Classe da tela inicial do aplicativo
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

// Estado da tela inicial
class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar (barra superior da tela)
      appBar: AppBar(
        toolbarHeight: 100, // Altura da AppBar
        centerTitle: true, // Centraliza o título
        title: Text(
          'Bem-vindo ao Criptografei!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red, // Cor de fundo da AppBar
        shape: RoundedRectangleBorder( // Borda arredondada inferior
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )),
      ),
      backgroundColor: Colors.white, // Cor de fundo da tela

      // Corpo da tela
      body: Stack(
        children: [
          // Faixa verde no rodapé
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          // Conteúdo principal centralizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Espaçamento

                // Botão para entrar no app
                ElevatedButton(
                  onPressed: () {
                    // Ao clicar, redireciona para a tela principal com as opções de criptografia
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomBarComponent(
                          pages: [
                            TranspositionScreen(), // Tela de cifra por transposição
                            CaeserCipherScreen(), // Tela de cifra de César
                            UniqueKeyCipherScreen(), // Tela de cifra com chave única
                          ],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60), // Tamanho mínimo do botão
                      backgroundColor: Colors.white, // Cor de fundo
                      elevation: 10), // Sombra
                  child: const Text(
                    'Entrar no APP',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20), // Espaçamento

                // Botão para abrir o diálogo de créditos
                ElevatedButton(
                  onPressed: () {
                    // Mostra uma caixa de diálogo com os créditos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white, // Cor do fundo da caixa
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                          ),
                          title: Text(
                            'Créditos',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          actions: [
                            // Botão para fechar a caixa de diálogo
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha a caixa
                              },
                              child: Text(
                                'Fechar',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              ),
                            )
                          ],
                          content: Text(
                            'Trabalho desenvolvido por:\n\nIsac Diógenes\nJoão Victor',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60), // Tamanho do botão
                      backgroundColor: Colors.white,
                      elevation: 10),
                  child: const Text(
                    'Créditos',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
