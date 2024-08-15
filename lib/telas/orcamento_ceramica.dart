import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orcamento_pedreiro/database/db.dart';

import '../modelos/material_item.dart';
import '../modelos/material_modelo.dart';
import '../modelos/orcamento_modelo.dart';
import '../modelos/tipo_orcamento.dart';

class OrcamentoCeramica extends StatefulWidget {
  const OrcamentoCeramica({super.key});

  @override
  State<OrcamentoCeramica> createState() => _OrcamentoCeramicaState();
}

class _OrcamentoCeramicaState extends State<OrcamentoCeramica> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController valorMaoObraController =
      TextEditingController(text: '0');
  final TextEditingController prazoController =
      TextEditingController(text: '0');
  final TextEditingController areaOrcadaController =
      TextEditingController(text: '0');

  final List<MaterialItem> _materiais = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validarOrcamento() {
    if (_formKey.currentState!.validate()) {
      salvarSair();
    }
  }

  String? _validarCliente(valor) {
    if (valor!.isEmpty) {
      return "Informe o Nome do cliente";
    }
    return null;
  }

  String? _validarNumeros(valor) {
    if (valor!.isEmpty) {
      return "Insira um valor";
    } else if (int.parse(valor!) <= 0) {
      return "Insira um valor maior que 0";
    }
    return null;
  }

  void salvarSair() async {
    await _salvarOrcamento();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Orçamento inserido com sucesso!')),
    );

    Navigator.pop(context); // Voltar para a tela anterior
  }

  void _gerarMateriais() {
    _materiais.clear();

    final int metroQuadrados = int.parse(areaOrcadaController.text) ?? 0;

    if (metroQuadrados > 0) {
      setState(() {
        _materiais.addAll([
          MaterialItem(
              nomeMaterial: "CERÂMICA",
              quantidade: (metroQuadrados * 1.10).ceilToDouble()),
          MaterialItem(
              nomeMaterial: "ARGAMASSA",
              quantidade: (metroQuadrados / 4).ceilToDouble()),
          MaterialItem(
              nomeMaterial: "REJUNTE",
              quantidade: (metroQuadrados / 5.6).ceilToDouble()),
        ]);
      });
    }
  }

  double arredondarAcima(valor, base) {
    return (valor / base).ceil() * base;
  }

  // Função para adicionar um novo material à lista
  void _adicionarMaterial() {
    setState(() {
      // Adiciona um material vazio
      _materiais.add(MaterialItem(nomeMaterial: '', quantidade: 0));
    });
  }

  void _removerUltimoMaterial() {
    setState(() {
      if (_materiais.isNotEmpty) {
        _materiais.removeLast(); // Remove o último item da lista
      }
    });
  }

  Future<void> _salvarOrcamento() async {
    DB db = DB.instancia;

    // Criando um orçamento
    OrcamentoModelo novoOrcamento = OrcamentoModelo(
        tipoOrcamento: TipoOrcamento.ceramica,
        cliente: clienteController.text,
        data: DateTime.now(),
        valorMaoObra: double.parse(valorMaoObraController.text),
        prazoDias: prazoController.text,
        areaOrcada: areaOrcadaController.text);

    // Inserindo o orçamento no banco de dados
    int orcamentoId = await db.inserirOrcamento(novoOrcamento);
    novoOrcamento.idOrcamento = orcamentoId;

    print('Orçamento inserido com ID: $orcamentoId');

    List<MaterialModelo> listaMateriais =
        converterParaMaterialModelo(_materiais, orcamentoId);

    await db.inserirListaMateriais(listaMateriais);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldFormularioPadrao();
  }

  Scaffold ScaffoldFormularioPadrao() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orçamento de Cerâmica",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
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
                    controller: clienteController,
                    decoration: InputDecoration(
                      hintText: 'Informe o nome do cliente',
                      labelText: 'Nome do cliente',
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
                    controller: prazoController,
                    decoration: InputDecoration(
                      hintText: 'Informe o prazo em dias',
                      labelText: 'Prazo (dias)',
                      labelStyle: const TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarNumeros,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: areaOrcadaController,
                    decoration: InputDecoration(
                      hintText: 'Informe os m² da Ceramica',
                      labelText: 'Área Orçada (m²)',
                      labelStyle: const TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.square_foot),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarNumeros,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: valorMaoObraController,
                    decoration: InputDecoration(
                      hintText: 'Valor em reais',
                      labelText: 'Custo da Mão de Obra (m²)',
                      labelStyle: const TextStyle(
                        fontSize: 21,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.monetization_on_outlined),
                      prefixText: 'R\$ ',
                      suffix: const Text(
                        "reais",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: _validarNumeros,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 75,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      onPressed: _gerarMateriais,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add_sharp,
                            color: Colors.white,
                          ),
                          Text(
                            'GERAR LISTA DE MATERIAIS',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: _materiais.map((material) {
                      return Card(
                        margin: EdgeInsets.all(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: ListTile(
                            title: TextFormField(
                              initialValue: material.nomeMaterial,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Digite o nome do material',
                                labelText: 'Material',
                                labelStyle: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 25, // Aumenta o tamanho da fonte
                                    color: Colors
                                        .lightBlueAccent // Define a cor da fonte
                                    ),
                              ),
                              onChanged: (valor) {
                                material.nomeMaterial = valor;
                              },
                            ),
                            subtitle: TextFormField(
                              initialValue: material.quantidade.toString(),
                              decoration: const InputDecoration(
                                hintText: 'Digite a quantidade',
                                labelText: "Quantidade",
                                labelStyle: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 25, // Aumenta o tamanho da fonte
                                  color: Colors
                                      .lightBlueAccent, // Define a cor da fonte
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[\d.]'))
                              ],
                              onChanged: (valor) {
                                setState(() {
                                  material.quantidade =
                                      double.tryParse(valor) ?? 0;
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
                            Icon(
                              Icons.playlist_remove,
                              color: Colors.white,
                            ),
                            Text(
                              'RETIRAR ULTIMO MATERIAL',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_materiais.isNotEmpty) const SizedBox(height: 50.0),
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
                  const SizedBox(height: 16.0),
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
                            'SALVAR ORÇAMENTO',
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
