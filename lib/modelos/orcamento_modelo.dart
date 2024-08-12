import 'package:orcamento_pedreiro/modelos/tipo_orcamento.dart';

class OrcamentoModelo {
  int? idOrcamento;
  TipoOrcamento tipoOrcamento;
  String cliente;
  DateTime data;
  double valorMaoObra;
  String prazoDias;
  String areaOrcada;

  OrcamentoModelo({
    this.idOrcamento,
    required this.tipoOrcamento,
    required this.cliente,
    required this.data,
    required this.valorMaoObra,
    required this.prazoDias,
    required this.areaOrcada,
  });
// Converte um Map para um objeto OrcamentoModelo
  factory OrcamentoModelo.fromMap(Map<String, dynamic> map) {
    return OrcamentoModelo(
      idOrcamento: map['id_orcamento'],
      tipoOrcamento: TipoOrcamento.values.firstWhere(
        (e) => e.toString() == 'TipoOrcamento.${map['tipo_orcamento']}',
      ),
      cliente: map['cliente'],
      data: DateTime.fromMillisecondsSinceEpoch(map['data']),
      valorMaoObra: map['valor_mao_obra'],
      prazoDias: map['prazo_dias'],
      areaOrcada: map['area_orcada'],
    );
  }

  // Converte um objeto OrcamentoModelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id_orcamento': idOrcamento,
      'tipo_orcamento':
          tipoOrcamento.toString().split('.').last, // Converte enum para String
      'cliente': cliente,
      'data': data.millisecondsSinceEpoch, // Armazenando timestamp
      'valor_mao_obra': valorMaoObra,
      'prazo_dias': prazoDias,
      'area_orcada': areaOrcada,
    };
  }
}
