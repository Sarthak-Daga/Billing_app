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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
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

      photoPath TEXT,

      notes TEXT,

      deviceType TEXT,

      status TEXT,

      soldTo TEXT,
      soldMobile TEXT,

      sellingPrice TEXT,
      soldDate TEXT
    )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE customers ADD COLUMN notes TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN deviceType TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN status TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN soldTo TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN soldMobile TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN sellingPrice TEXT');

      await db.execute('ALTER TABLE customers ADD COLUMN soldDate TEXT');
    }
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
