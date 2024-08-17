import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orcamento_pedreiro/database/db.dart';
import 'package:orcamento_pedreiro/telas/tela_detalhes_orcamento.dart';
import 'package:orcamento_pedreiro/telas/tela_editar_orcamento.dart';

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
        // Ordenar os orçamentos pela data em ordem decrescente (mais recente primeiro)
        _orcamentos.sort((a, b) => b.data.compareTo(a.data));
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
        centerTitle: true,
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
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                'Cliente: ${orcamento.cliente.toUpperCase()}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Orçamento: ${orcamento.tipoOrcamento.toString().split('.').last.toUpperCase()}',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Valor mão de obra : ${real.format(orcamento.valorMaoObra * double.parse(orcamento.areaOrcada))}',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15),
                                  ),
                                  Text(
                                    'Prazo: ${orcamento.prazoDias} dias',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 17),
                                  ),
                                  Text(
                                    'Data do orçamento: ${dateFormat.format(orcamento.data)}'
                                        .toUpperCase(),
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.chevron_right),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TelaDetalhesOrcamento(
                                            orcamento: orcamento,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Ver Detalhes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TelaEditarOrcamento(
                                            orcamento: orcamento,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Editar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
