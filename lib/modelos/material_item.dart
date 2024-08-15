// Classe que representa um item de material
class MaterialItem {
  String nomeMaterial;
  double quantidade;

  MaterialItem({required this.nomeMaterial, required this.quantidade});

  // Converte um objeto MaterialModelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'nome_material': nomeMaterial,
      'quantidade': quantidade,
    };
  }
}
