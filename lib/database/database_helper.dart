import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('records.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT,
        mobileNumber TEXT,
        modelName TEXT,
        imei TEXT,
        purchaseDate TEXT,
        purchasePrice TEXT,
        photoPath TEXT
      )
    ''');
  }

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    final db = await instance.database;

    return await db.insert('customers', row);
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await instance.database;

    return await db.query('customers', orderBy: 'id DESC');
  }

  Future<int> deleteCustomer(int id) async {
    final db = await instance.database;

    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCustomer(Map<String, dynamic> customer) async {
    final db = await instance.database;

    return await db.update(
      'customers',
      customer,
      where: 'id = ?',
      whereArgs: [customer['id']],
    );
  }
}
