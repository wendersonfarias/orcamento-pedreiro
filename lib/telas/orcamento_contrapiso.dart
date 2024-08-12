import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/database/db.dart';

import '../modelos/material_modelo.dart';
import '../modelos/orcamento_modelo.dart';
import '../modelos/tipo_orcamento.dart';

class OrcamentoContrapiso extends StatefulWidget {
  const OrcamentoContrapiso({super.key});

  @override
  State<OrcamentoContrapiso> createState() => _OrcamentoContrapisoState();
}

class _OrcamentoContrapisoState extends State<OrcamentoContrapiso> {
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController prazoController = TextEditingController();

  Future<void> _salvarOrcamento() async {
    DB db = DB.instancia;

    // Criando um orçamento
    OrcamentoModelo newOrcamento = OrcamentoModelo(
      areaOrcada: '1',
      tipoOrcamento: TipoOrcamento.contrapiso,
      cliente: clienteController.text,
      data: DateTime.now(),
      valorMaoObra: double.parse(valorController.text),
      prazoDias: prazoController.text,
    );

    // Inserindo o orçamento no banco de dados
    int orcamentoId = await db.insertOrcamento(newOrcamento.toMap());
    newOrcamento.idOrcamento = orcamentoId;

    print('Orçamento inserido com ID: $orcamentoId');

    // Adicionando um material para o orçamento
    MaterialModelo newMaterial = MaterialModelo(
      nomeMaterial: 'Tijolos',
      quantidade: '1000',
      idOrcamento: orcamentoId,
    );

    //int materialId = await db.insertMaterial(newMaterial.toMap());
    int materialId = 1;
    print('Material inserido com ID: $materialId');

    // Verificando se o orçamento foi salvo
    Map<String, dynamic>? orcamentoSalvo = await db.getOrcamento(orcamentoId);
    if (orcamentoSalvo != null) {
      print('Orçamento salvo: $orcamentoSalvo');
    } else {
      print('Orçamento não encontrado.');
    }

    // Verificando se o material foi salvo
    Map<String, dynamic>? materialSalvo = await db.getMaterial(materialId);
    if (materialSalvo != null) {
      print('Material salvo: $materialSalvo');
    } else {
      print('Material não encontrado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do CONTRAPISO"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: clienteController,
              decoration: InputDecoration(labelText: 'Cliente'),
            ),
            TextField(
              controller: valorController,
              decoration: InputDecoration(labelText: 'Valor da Mão de Obra'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: prazoController,
              decoration: InputDecoration(labelText: 'Prazo (dias)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                // Salva o orçamento e espera a conclusão
                await _salvarOrcamento();

                // Mostra um Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Orçamento inserido com sucesso!')),
                );

                // Volta para a tela anterior
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
