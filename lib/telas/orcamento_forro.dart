import 'package:flutter/material.dart';

class OrcamentoForro extends StatefulWidget {
  const OrcamentoForro({super.key});

  @override
  State<OrcamentoForro> createState() => _OrcamentoForroState();
}

class _OrcamentoForroState extends State<OrcamentoForro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do Forro"),
      ),
    );
  }
}
