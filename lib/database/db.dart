import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  //CONSTRUTOR COM ACESSO PRIVADO

  DB._();

  //Criar instancia de DB
  static final DB instancia = DB._();

  //Instancia do SQLite
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'banco_orcamentos.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(db, versao) async {
    await db.execute(_orcamento);
    await db.execute(_material);
  }

  String get _orcamento => '''
    CREATE TABLE orcamento (
    id_orcamento INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo_orcamento TEXT,
    cliente TEXT,
    data TEXT,
    valor_mao_obra REAL,
    prazo_dias TEXT,
    status_orcamento TEXT );
  ''';

  String get _material => '''
    CREATE TABLE Material (
    id_material INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_material TEXT,
    quantidade_material TEXT,
    id_orcamento INTEGER,
    FOREIGN KEY (id_orcamento) REFERENCES orcamento(id_orcamento) );
  ''';

  // CRUD para a tabela orcamento

  // Create
  Future<int> insertOrcamento(Map<String, dynamic> orcamento) async {
    Database db = await database;
    return await db.insert('orcamento', orcamento);
  }

  // Read all
  Future<List<Map<String, dynamic>>> getOrcamentos() async {
    Database db = await database;
    return await db.query('orcamento');
  }

  // Read one
  Future<Map<String, dynamic>?> getOrcamento(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'orcamento',
      where: 'id_orcamento = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Update
  Future<int> updateOrcamento(Map<String, dynamic> orcamento) async {
    Database db = await database;
    return await db.update(
      'orcamento',
      orcamento,
      where: 'id_orcamento = ?',
      whereArgs: [orcamento['id_orcamento']],
    );
  }

  // Delete
  Future<int> deleteOrcamento(int id) async {
    Database db = await database;
    return await db.delete(
      'orcamento',
      where: 'id_orcamento = ?',
      whereArgs: [id],
    );
  }

  // CRUD para a tabela material

  Future<int> insertMaterial(Map<String, dynamic> material) async {
    Database db = await database;
    return await db.insert('material', material);
  }

  Future<List<Map<String, dynamic>>> getMateriais() async {
    Database db = await database;
    return await db.query('material');
  }

  Future<Map<String, dynamic>?> getMaterial(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'material',
      where: 'id_material = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getMateriaisPorOrcamento(
      int orcamentoId) async {
    Database db = await database;
    return await db.query(
      'material',
      where: 'id_orcamento = ?',
      whereArgs: [orcamentoId],
    );
  }

  Future<int> updateMaterial(Map<String, dynamic> material) async {
    Database db = await database;
    return await db.update(
      'material',
      material,
      where: 'id_material = ?',
      whereArgs: [material['id_material']],
    );
  }

  Future<int> deleteMaterial(int id) async {
    Database db = await database;
    return await db.delete(
      'material',
      where: 'id_material = ?',
      whereArgs: [id],
    );
  }
}
