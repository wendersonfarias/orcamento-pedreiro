import 'package:flutter/material.dart';

import '../constantes.dart';

const tamanhoIconeConteudoIcone = 95.0;

class ConteudoIcone extends StatelessWidget {
  ConteudoIcone({required this.nomeImagem, required this.descricao});

  final String nomeImagem;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageIcon(
          AssetImage('imagens/$nomeImagem.png'),
          size: tamanhoIconeConteudoIcone,
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            descricao,
            style: kDescricaoTextStyle,
          ),
        ),
      ],
    );
  }
}
