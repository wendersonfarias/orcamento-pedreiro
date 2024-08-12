import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/telas/orcamento_calcada.dart';
import 'package:orcamento_pedreiro/telas/orcamento_ceramica.dart';
import 'package:orcamento_pedreiro/telas/orcamento_contrapiso.dart';
import 'package:orcamento_pedreiro/telas/orcamento_forro.dart';
import 'package:orcamento_pedreiro/telas/orcamento_muro.dart';
import 'package:orcamento_pedreiro/telas/orcamento_telhado.dart';
import 'package:orcamento_pedreiro/telas/tela_historico.dart';
import 'package:orcamento_pedreiro/telas/tela_orcamento.dart';
import 'package:orcamento_pedreiro/telas/tela_principal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OrcamentoMain());
}

class OrcamentoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF616161),
        scaffoldBackgroundColor: Color(0xFF616161),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TelaPrincipal(),
        '/orcamento': (context) => TelaOrcamento(),
        '/historico': (context) => TelaHistorico(),
        '/orcamento-muro': (context) => OrcamentoMuro(),
        '/orcamento-ceramica': (context) => OrcamentoCeramica(),
        '/orcamento-calcada': (context) => OrcamentoCalcada(),
        '/orcamento-forro': (context) => OrcamentoForro(),
        '/orcamento-telhado': (context) => OrcamentoTelhado(),
        '/orcamento-contrapiso': (context) => OrcamentoContrapiso(),
      },
    );
  }
}
