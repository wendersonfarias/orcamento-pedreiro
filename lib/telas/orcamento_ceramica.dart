import 'package:flutter/material.dart';

class OrcamentoCeramica extends StatefulWidget {
  const OrcamentoCeramica({super.key});

  @override
  State<OrcamentoCeramica> createState() => _OrcamentoCeramicaState();
}

class _OrcamentoCeramicaState extends State<OrcamentoCeramica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do Ceramica"),
      ),
    );
  }
}
