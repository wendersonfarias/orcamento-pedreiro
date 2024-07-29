import 'package:flutter/material.dart';

class OrcamentoContrapiso extends StatefulWidget {
  const OrcamentoContrapiso({super.key});

  @override
  State<OrcamentoContrapiso> createState() => _OrcamentoContrapisoState();
}

class _OrcamentoContrapisoState extends State<OrcamentoContrapiso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orcamento Contrapiso"),
      ),
    );
  }
}
