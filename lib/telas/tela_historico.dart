import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/database/db.dart';

import '../modelos/orcamento_modelo.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  List<OrcamentoModelo> _orcamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarOrcamentos();
  }

  Future<void> _carregarOrcamentos() async {
    try {
      DB db = DB.instancia;
      List<Map<String, dynamic>> orcamentoMaps = await db.getOrcamentos();
      setState(() {
        _orcamentos =
            orcamentoMaps.map((map) => OrcamentoModelo.fromMap(map)).toList();
        _isLoading = false;

        print(_orcamentos);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro ao carregar orçamentos: $e');
      // Adicionar tratamento de erro adequado, como mostrar uma mensagem para o usuário.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orçamentos Salvos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orcamentos.length,
              itemBuilder: (context, index) {
                OrcamentoModelo orcamento = _orcamentos[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Cliente: ${orcamento.cliente}'),
                    subtitle: Text('Tipo: ${orcamento.tipoOrcamento}\n'
                        'Valor: R\$ ${orcamento.valorMaoObra}\n'
                        'Prazo: ${orcamento.prazoDias} '),
                    onTap: () {
                      // Ação ao clicar no Card
                    },
                  ),
                );
              },
            ),
    );
  }
}
