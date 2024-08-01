class OrcamentoModelo {
  int? idOrcamento;
  String tipoOrcamento;
  String cliente;
  String data;
  double valorMaoObra;
  String prazoDias;
  String statusOrcamento;

  OrcamentoModelo({
    this.idOrcamento,
    required this.tipoOrcamento,
    required this.cliente,
    required this.data,
    required this.valorMaoObra,
    required this.prazoDias,
    required this.statusOrcamento,
  });
// Converte um Map para um objeto OrcamentoModelo
  factory OrcamentoModelo.fromMap(Map<String, dynamic> map) {
    return OrcamentoModelo(
      idOrcamento: map['id_orcamento'],
      tipoOrcamento: map['tipo_orcamento'],
      cliente: map['cliente'],
      data: map['data'],
      valorMaoObra: map['valor_mao_obra'],
      prazoDias: map['prazo_dias'],
      statusOrcamento: map['status_orcamento'],
    );
  }

  // Converte um objeto OrcamentoModelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id_orcamento': idOrcamento,
      'tipo_orcamento': tipoOrcamento,
      'cliente': cliente,
      'data': data,
      'valor_mao_obra': valorMaoObra,
      'prazo_dias': prazoDias,
      'status_orcamento': statusOrcamento,
    };
  }
}
