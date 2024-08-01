class MaterialModelo {
  int? idMaterial;
  String nomeMaterial;
  String quantidadeMaterial;
  int idOrcamento;
  MaterialModelo({
    this.idMaterial,
    required this.nomeMaterial,
    required this.quantidadeMaterial,
    required this.idOrcamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_material': idMaterial,
      'nome_material': nomeMaterial,
      'quantidade_material': quantidadeMaterial,
      'id_orcamento': idOrcamento,
    };
  }
}
