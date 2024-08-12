import 'package:orcamento_pedreiro/modelos/material_item.dart';

class MaterialModelo {
  int? idMaterial;
  String nomeMaterial;
  String quantidade;
  int idOrcamento;

  MaterialModelo({
    this.idMaterial,
    required this.nomeMaterial,
    required this.quantidade,
    required this.idOrcamento,
  });

  // Converte um Map para um objeto MaterialModelo
  factory MaterialModelo.fromMap(Map<String, dynamic> map) {
    return MaterialModelo(
      idMaterial: map['id_material'],
      nomeMaterial: map['nome_material'],
      quantidade: map['quantidade'],
      idOrcamento: map['id_orcamento'],
    );
  }

  // Converte um objeto MaterialModelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id_material': idMaterial,
      'nome_material': nomeMaterial,
      'quantidade': quantidade,
      'id_orcamento': idOrcamento,
    };
  }
}

List<MaterialModelo> converterParaMaterialModelo(
    List<MaterialItem> lista, int idOrcamento) {
  return lista.map((item) {
    return MaterialModelo(
      nomeMaterial: item.nomeMaterial,
      quantidade: item.quantidade.toString(),
      idOrcamento: idOrcamento,
    );
  }).toList();
}
