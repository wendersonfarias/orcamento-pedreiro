import 'package:flutter/material.dart';
import 'package:orcamento_pedreiro/database/db.dart';
import 'package:orcamento_pedreiro/modelos/tipo_orcamento.dart';

import '../modelos/material_modelo.dart';
import '../modelos/orcamento_modelo.dart';

class OrcamentoCeramica extends StatefulWidget {
  const OrcamentoCeramica({super.key});

  @override
  State<OrcamentoCeramica> createState() => _OrcamentoCeramicaState();
}

class _OrcamentoCeramicaState extends State<OrcamentoCeramica> {
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController prazoController = TextEditingController();

  String testeBanco({
    required String cliente,
    required double maoObra,
    required String prazo,
  }) {
    setState(() async {
      DB db = DB.instancia;

      // Criando um orçamento
      OrcamentoModelo newOrcamento = OrcamentoModelo(
        areaOrcada: '1',
        tipoOrcamento: TipoOrcamento.ceramica,
        cliente: cliente,
        data: DateTime.now(),
        valorMaoObra: maoObra,
        prazoDias: prazo,
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
    });

    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamento do CERAMICA"),
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
                String ok = await testeBanco(
                    cliente: clienteController.text,
                    maoObra: double.parse(valorController.text),
                    prazo: prazoController.text);
                print(ok);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Orçamento inserido com sucesso!')),
                );
                Navigator.pushNamed(
                    context, '/'); // Voltar para a tela anterior
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
