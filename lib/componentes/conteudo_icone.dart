import 'package:flutter/material.dart';

import '../constantes.dart';

const tamanhoIconeConteudoIcone = 110.0;

class ConteudoIcone extends StatelessWidget {
  ConteudoIcone({required this.nomeImagem, required this.descricao});

  final String nomeImagem;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ImageIcon(
            AssetImage('imagens/$nomeImagem.png'),
            size: tamanhoIconeConteudoIcone,
          ),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            descricao,
            style: kDescricaoTextStyle,
          ),
        ),
      ],
    );
  }
}
