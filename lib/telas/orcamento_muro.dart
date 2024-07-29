import 'package:flutter/material.dart';

class OrcamentoMuro extends StatefulWidget {
  const OrcamentoMuro({super.key});

  @override
  State<OrcamentoMuro> createState() => _OrcamentoMuroState();
}

class _OrcamentoMuroState extends State<OrcamentoMuro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do Muro"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Votar a Tela de Orçamentos'),
            ),
          ),
        ],
      ),
    );
  }
}
