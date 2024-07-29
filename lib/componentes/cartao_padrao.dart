import 'package:flutter/material.dart';

import '../constantes.dart';

class CartaoPadrao extends StatelessWidget {
  final VoidCallback? aoPressionar;
  final Widget? filhoCartao;

  CartaoPadrao({this.aoPressionar, this.filhoCartao});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        child: filhoCartao,
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: kCorAtivaCartaoPadrao,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
