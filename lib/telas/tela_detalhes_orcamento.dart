import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orcamento_pedreiro/database/db.dart';
import 'package:orcamento_pedreiro/services/pdf_service.dart';

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
  final PdfService pdfService = new PdfService();
  String tipoOrcamento = '';

  List<MaterialModelo> _materiais = [];
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final DateFormat dateFormat =
      DateFormat('dd/MM/yyyy'); // Define o formato de data

  @override
  void initState() {
    super.initState();
    tipoOrcamento =
        widget.orcamento.tipoOrcamento.toString().split('.').last.toUpperCase();
    _carregarMateriais().then((materiais) {
      setState(() {
        _materiais = materiais;
      });
    });
  }

  Future<List<MaterialModelo>> _carregarMateriais() async {
    DB db = DB.instancia;
    List<MaterialModelo> materiais =
        await db.buscarMateriaisOrcamentoId(widget.orcamento.idOrcamento!);
    return materiais;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Orçamento'),
        backgroundColor: Colors.blueGrey,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              //color: Colors.,
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cliente: ${widget.orcamento.cliente.toUpperCase()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Orçamento: ${tipoOrcamento}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Valor mão de obra: ${real.format(widget.orcamento.valorMaoObra * double.parse(widget.orcamento.areaOrcada))}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'PRAZO: ${widget.orcamento.prazoDias} DIAS',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Data do orçamento: ${dateFormat.format(widget.orcamento.data)}'
                          .toUpperCase(),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            const Center(
              child: Text(
                "Lista de Materiais",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Column(
              children: _materiais.map((material) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(
                        material.nomeMaterial,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      subtitle: Text(
                        'Quantidade: ${double.parse(material.quantidade).toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 75,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () async {
                  final data =
                      await pdfService.gerarPDF(widget.orcamento, _materiais);
                  pdfService.salvarAbrir('Orçamento-$tipoOrcamento', data);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    Text(
                      'Gerar PDF e Abrir',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 75,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  final data =
                      await pdfService.gerarPDF(widget.orcamento, _materiais);
                  pdfService.compartilharPDF('Orçamento-$tipoOrcamento', data);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage('imagens/whatsapp.png'),
                      size: 37,
                      color: Colors.white,
                    ),
                    Text(
                      ' Mandar pelo Whatsapp',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 75,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    Text(
                      'Deletar Orçamento',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza de que deseja apagar este orçamento '
                  'e os materiais desse orçamento?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await DB.instancia
                    .deleteOrcamentoComMateriais(widget.orcamento.idOrcamento!);
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Volta para a tela anterior
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }
}
