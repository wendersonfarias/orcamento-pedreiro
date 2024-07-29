import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/telas/tela_principal.dart';

void main() => runApp( Orcamento());


class Orcamento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF616161),
        scaffoldBackgroundColor: Color(0xFF616161),
      ),
      home: SafeArea(child: TelaPrincipal()),
    );
  }
}


