import 'package:desafio_dio_projeto_final/view/atualizar_contato_page.dart';
import 'package:desafio_dio_projeto_final/view/cadastro_contato_page.dart';
import 'package:desafio_dio_projeto_final/view/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (_) => const HomePage(),
      "/cadastro": (_) => const CadastroContatoPage(),
      "/atualizar": (_) => const AtualizarContatoPage()
      
    },
  ));
}