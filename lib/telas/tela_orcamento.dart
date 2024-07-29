import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/telas/orcamento_muro.dart';

import '../componentes/cartao_padrao.dart';
import '../componentes/conteudo_icone.dart';

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
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "calcada",
                      descricao: "Calçada",
                    ),
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
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    filhoCartao: ConteudoIcone(
                      nomeImagem: "cobertura",
                      descricao: "Telhado",
                    ),
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
