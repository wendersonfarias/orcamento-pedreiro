import 'package:flutter/material.dart';

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
      body: ListView(
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () {
                      Navigator.pushNamed(context, '/orcamento-muro');
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
                      Navigator.pushNamed(context, '/orcamento-contrapiso');
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
                      Navigator.pushNamed(context, '/orcamento-forro');
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
                      Navigator.pushNamed(context, '/orcamento-calcada');
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
                      Navigator.pushNamed(context, '/orcamento-ceramica');
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
                      Navigator.pushNamed(context, '/orcamento-telhado');
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
