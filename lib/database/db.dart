import 'package:orcamento_pedreiro/modelos/material_modelo.dart';
import 'package:orcamento_pedreiro/modelos/orcamento_modelo.dart';
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
      join(await getDatabasesPath(), 'orçamento10.db'),
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
    tipo_orcamento TEXT NOT NULL,
    cliente TEXT NOT NULL,
    data INTEGER NOT NULL,
    valor_mao_obra REAL NOT NULL,
    prazo_dias TEXT NOT NULL,
    area_orcada TEXT NOT NULL );
  ''';

  String get _material => '''
    CREATE TABLE Material (
      id_material INTEGER PRIMARY KEY AUTOINCREMENT,
      nome_material TEXT NOT NULL,
      quantidade TEXT NOT NULL,
      id_orcamento INTEGER NOT NULL,
      FOREIGN KEY (id_orcamento) REFERENCES orcamento(id_orcamento));
  ''';

  // CRUD para a tabela orcamento

  // Create
  Future<int> insertOrcamento(Map<String, dynamic> orcamento) async {
    Database db = await database;
    return await db.insert('orcamento', orcamento);
  }

  Future<int> inserirOrcamento(OrcamentoModelo orcamento) async {
    Database db = await database;
    return await db.insert(
      'orcamento',
      orcamento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  DateTime getDateFromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // Read all
  Future<List<Map<String, dynamic>>> getOrcamentos() async {
    Database db = await database;
    return await db.query('orcamento');
  }

  // Read all
  Future<List<OrcamentoModelo>> buscarOrcamentos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orcamento');

    return List.generate(maps.length, (i) {
      return OrcamentoModelo.fromMap(maps[i]);
    });
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

  Future<OrcamentoModelo?> buscarOrcamentoPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orcamento',
      where: 'id_orcamento = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return OrcamentoModelo.fromMap(maps.first);
    } else {
      return null; // Retorna null se o orçamento não for encontrado
    }
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

  // Future<int> insertMaterial(Map<String, dynamic> material) async {
  //   Database db = await database;
  //   return await db.insert(
  //     'material',
  //     material.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<int> inserirMaterial(MaterialModelo material) async {
    Database db = await database;
    return await db.insert(
      'material',
      material.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> inserirListaMateriais(List<MaterialModelo> materiais) async {
    final db = await database;
    Batch batch = db.batch();

    for (var material in materiais) {
      batch.insert(
        'material',
        material.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getMateriais() async {
    Database db = await database;
    return await db.query('material');
  }

  Future<List<MaterialModelo>> buscarMateriais() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('material');

    return List.generate(maps.length, (i) {
      return MaterialModelo.fromMap(maps[i]);
    });
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

  // Método para buscar materiais pelo ID do orçamento
  Future<List<MaterialModelo>> buscarMateriaisOrcamentoId(
      int idOrcamento) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'material',
      where: 'id_orcamento = ?',
      whereArgs: [idOrcamento],
    );

    return List.generate(maps.length, (i) {
      return MaterialModelo.fromMap(maps[i]);
    });
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
