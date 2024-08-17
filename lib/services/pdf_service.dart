import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../modelos/material_modelo.dart';
import '../modelos/orcamento_modelo.dart';

class PdfService {
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<Uint8List> gerarPDF(
    OrcamentoModelo orcamento,
    List<MaterialModelo> materiais,
  ) async {
    // Carregar a fonte personalizada
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final PDF = pw.Document();
    final real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy');

    PDF.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Padding(
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              pw.Container(
                width: double.infinity,
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blueGrey100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.blueGrey800, width: 1),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        'Detalhes do Orçamento',
                        style: pw.TextStyle(
                            font: ttf,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Cliente: ${orcamento.cliente.toUpperCase()}',
                      style: pw.TextStyle(font: ttf, fontSize: 18),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Tipo de Orçamento: ${orcamento.tipoOrcamento.toString().split('.').last.toUpperCase()}',
                      style: pw.TextStyle(font: ttf, fontSize: 16),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(children: [
                      pw.Text(
                        'Valor de mão de obra: ',
                        style: pw.TextStyle(font: ttf, fontSize: 16),
                      ),
                      pw.Text(
                        '${real.format(orcamento.valorMaoObra * double.parse(orcamento.areaOrcada))}',
                        style: pw.TextStyle(font: ttf, fontSize: 17),
                      ),
                    ]),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Prazo: ${orcamento.prazoDias} dias',
                      style: pw.TextStyle(font: ttf, fontSize: 16),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Data do orçamento: ${dateFormat.format(orcamento.data)}'
                          .toUpperCase(),
                      style: pw.TextStyle(font: ttf, fontSize: 16),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              // Lista de Materiais
              pw.Center(
                child: pw.Text(
                  'Lista de Materiais',
                  style: pw.TextStyle(
                      font: ttf, fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(width: 1, color: PdfColors.grey400),
                columnWidths: {
                  0: pw.FixedColumnWidth(
                      300), // Ajuste para corresponder ao container
                  1: pw.FixedColumnWidth(100),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('Material',
                                style: pw.TextStyle(
                                    font: ttf,
                                    fontSize: 19,
                                    fontWeight: pw.FontWeight.bold)),
                          )),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Quantidade',
                            style: pw.TextStyle(
                                font: ttf,
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...materiais.map(
                    (material) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            material.nomeMaterial,
                            style: pw.TextStyle(font: ttf, fontSize: 16),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              '${double.parse(material.quantidade).toStringAsFixed(0)}',
                              style: pw.TextStyle(font: ttf, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return PDF.save();
  }

  Future<void> salvarAbrir(String fileName, Uint8List byteList) async {
    try {
      final output = await getTemporaryDirectory();
      var filePath = "${output.path}/$fileName.pdf";
      final file = File(filePath);
      await file.writeAsBytes(byteList);
      await OpenFile.open(filePath);
    } catch (e) {
      print('Erro ao abrir o PDF: $e');
    }
  }

  Future<void> compartilharPDF(String fileName, Uint8List byteList) async {
    try {
      final output = await getTemporaryDirectory();
      var filePath = "${output.path}/$fileName.pdf";
      final file = File(filePath);
      await file.writeAsBytes(byteList);
      Share.shareXFiles([XFile(file.path)],
          text: 'Aqui está o PDF do orçamento');
    } catch (e) {
      print('Erro ao abrir o PDF: $e');
    }
  }
}
