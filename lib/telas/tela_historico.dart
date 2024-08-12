import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool _hasError = false;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  DateFormat dateFormat = DateFormat('dd/MM/yyyy'); // Define o formato de data

  @override
  void initState() {
    super.initState();
    _carregarOrcamentos();
  }

  Future<void> _carregarOrcamentos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      DB db = DB.instancia;
      List<Map<String, dynamic>> orcamentoMaps = await db.getOrcamentos();
      setState(() {
        _orcamentos =
            orcamentoMaps.map((map) => OrcamentoModelo.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Erro ao carregar orçamentos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orçamentos Salvos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarOrcamentos,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text('Erro ao carregar orçamentos. Tente novamente.'),
                )
              : RefreshIndicator(
                  onRefresh: _carregarOrcamentos,
                  child: ListView.builder(
                    itemCount: _orcamentos.length,
                    itemBuilder: (context, index) {
                      OrcamentoModelo orcamento = _orcamentos[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            'Cliente: ${orcamento.cliente}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo: ${orcamento.tipoOrcamento.toString().split('.').last}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Valor mão de obra : ${real.format(orcamento.valorMaoObra * double.parse(orcamento.areaOrcada))}',
                                style: TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Prazo: ${orcamento.prazoDias} dias',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              Text(
                                'Data do orçamento: ${dateFormat.format(orcamento.data)}',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // Ação ao clicar no Card
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
