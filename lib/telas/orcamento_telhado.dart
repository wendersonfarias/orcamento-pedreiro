import 'package:flutter/material.dart';

class OrcamentoTelhado extends StatefulWidget {
  const OrcamentoTelhado({super.key});

  @override
  State<OrcamentoTelhado> createState() => _OrcamentoTelhadoState();
}

class _OrcamentoTelhadoState extends State<OrcamentoTelhado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do Telhado"),
      ),
    );
  }
}
