import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/telas/orcamento_calcada.dart';
import 'package:orcamento_pedreiro/telas/orcamento_ceramica.dart';
import 'package:orcamento_pedreiro/telas/orcamento_forro.dart';
import 'package:orcamento_pedreiro/telas/orcamento_muro.dart';
import 'package:orcamento_pedreiro/telas/orcamento_telhado.dart';

import '../componentes/cartao_padrao.dart';
import '../componentes/conteudo_icone.dart';
import 'orcamento_contrapiso.dart';

class TelaOrcamento extends StatelessWidget {
  const TelaOrcamento({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Escolher Orçamento",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoMuro()));
                    },
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "tijolo",
                      descricao: "Muro",
                    ),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "piso",
                      descricao: "Contrapiso",
                    ),
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoContrapiso()));
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "teto",
                      descricao: "Forro PVC",
                    ),
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoForro()));
                    },
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "calcada",
                      descricao: "Calçada",
                    ),
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoCalcada()));
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "ceramica",
                      descricao: "Cerâmica",
                    ),
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoCeramica()));
                    },
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "cobertura",
                      descricao: "Telhado",
                    ),
                    aoPressionar: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrcamentoTelhado()));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
