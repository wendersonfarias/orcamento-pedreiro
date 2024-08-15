import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orcamento_pedreiro/database/db.dart';

import '../modelos/material_modelo.dart';
import '../modelos/orcamento_modelo.dart';

class TelaDetalhesOrcamento extends StatefulWidget {
  final OrcamentoModelo orcamento;

  const TelaDetalhesOrcamento({Key? key, required this.orcamento})
      : super(key: key);

  @override
  _TelaDetalhesOrcamentoState createState() => _TelaDetalhesOrcamentoState();
}

class _TelaDetalhesOrcamentoState extends State<TelaDetalhesOrcamento> {
  late TextEditingController _clienteController;
  late TextEditingController _valorController;
  late TextEditingController _prazoController;
  late TextEditingController _areaOrcadaController;
  late DateTime _data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<MaterialModelo> _materiais = [];

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController(text: widget.orcamento.cliente);
    _valorController =
        TextEditingController(text: widget.orcamento.valorMaoObra.toString());
    _prazoController = TextEditingController(text: widget.orcamento.prazoDias);
    _areaOrcadaController =
        TextEditingController(text: widget.orcamento.areaOrcada);
    _data = widget.orcamento.data;

    _carregarMateriais().then((materiais) {
      setState(() {
        _materiais = materiais;
      });
    });
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _valorController.dispose();
    _prazoController.dispose();
    _areaOrcadaController.dispose();
    super.dispose();
  }

  String? _validarCliente(valor) {
    if (valor!.isEmpty) {
      return "Informe o Nome do cliente";
    }
    return null;
  }

  void validarOrcamento() {
    if (_formKey.currentState!.validate()) {
      _salvarOrcamento();
    }
  }

  Future<List<MaterialModelo>> _carregarMateriais() async {
    DB db = DB.instancia;
    List<MaterialModelo> materiais =
        await db.buscarMateriaisOrcamentoId(widget.orcamento.idOrcamento!);

    return materiais;
  }

  Future<void> _salvarOrcamento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final orcamentoAtualizado = OrcamentoModelo(
      idOrcamento: widget.orcamento.idOrcamento,
      tipoOrcamento: widget.orcamento.tipoOrcamento,
      cliente: _clienteController.text,
      data: _data,
      valorMaoObra: double.tryParse(_valorController.text) ?? 0.0,
      prazoDias: _prazoController.text,
      areaOrcada: _areaOrcadaController.text,
    );

    try {
      DB db = DB.instancia;
      await db.updateOrcamento(orcamentoAtualizado.toMap());

      await db.atualizarListaMateriais(_materiais);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orçamento atualizado com sucesso!')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      print('Erro ao atualizar orçamento: $e');
    }
  }

  String? _validarCampo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Campo obrigatório';
    }
    final number = double.tryParse(valor);
    if (number == null || number <= 0) {
      return 'Insira um valor maior que 0';
    }
    return null;
  }

  void _adicionarMaterial() {
    setState(() {
      // Adiciona um material vazio
      _materiais.add(MaterialModelo(
        nomeMaterial: '',
        quantidade: '0',
        idOrcamento: widget.orcamento.idOrcamento!,
      ));
    });
  }

  void _removerUltimoMaterial() {
    setState(() {
      if (_materiais.isNotEmpty) {
        _materiais.removeLast(); // Remove o último item da lista
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Orçamento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: validarOrcamento,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _clienteController,
                    decoration: InputDecoration(
                      hintText: 'Informe o nome do cliente',
                      labelText: 'Nome do Cliente',
                      labelStyle: const TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: _validarCliente,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _prazoController,
                    decoration: InputDecoration(
                      hintText: 'Informe o prazo em dias',
                      labelText: 'Prazo (dias)',
                      labelStyle: TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarCampo,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _areaOrcadaController,
                    decoration: InputDecoration(
                      hintText: 'Informe a área orçada (m²)',
                      labelText: 'Área Orçada (m²)',
                      labelStyle: TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.square_foot),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarCampo,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      hintText: 'Valor em reais',
                      labelText: 'Custo da Mão de Obra (R\$)',
                      labelStyle: TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.monetization_on_outlined),
                      prefixText: 'R\$',
                      suffix: const Text(
                        'reais',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarCampo,
                  ),
                  const SizedBox(height: 25.0),
                  const Center(
                      child: Text(
                    "Lista de Materiais",
                    style: TextStyle(fontSize: 25),
                  )),
                  Column(
                    children: _materiais.map((material) {
                      return Card(
                        margin: EdgeInsets.all(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: ListTile(
                            title: TextFormField(
                              initialValue: material.nomeMaterial,
                              decoration: const InputDecoration(
                                hintText: 'Digite o nome do material',
                                labelText: 'Material',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              onChanged: (valor) {
                                setState(() {
                                  material.nomeMaterial = valor;
                                });
                              },
                            ),
                            subtitle: TextFormField(
                              initialValue: material.quantidade.toString(),
                              decoration: const InputDecoration(
                                hintText: 'Digite a quantidade',
                                labelText: 'Quantidade',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[\d.]'))
                              ],
                              onChanged: (valor) {
                                setState(() {
                                  material.quantidade = valor ?? '0.0';
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_materiais.isNotEmpty) const SizedBox(height: 50.0),
                  if (_materiais.isNotEmpty)
                    SizedBox(
                      height: 75,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: _removerUltimoMaterial,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.playlist_remove, color: Colors.white),
                            Text(
                              'REMOVER ÚLTIMO MATERIAL',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  //const SizedBox(height: 16.0),
                  if (_materiais.isNotEmpty) const SizedBox(height: 30.0),
                  SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: _adicionarMaterial,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_sharp,
                            color: Colors.white,
                          ),
                          Text(
                            'ADICIONAR MATERIAL',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: validarOrcamento,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          Text(
                            'ATUALIZAR ORÇAMENTO',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
