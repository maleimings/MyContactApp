import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManager = DatabaseManager._internal();

  DatabaseManager._internal();

  static DatabaseManager get instance => _databaseManager;

  static Database? _database;

  final _initDatabaseMemoizer = AsyncMemoizer<Database>();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabaseMemoizer.runOnce(() async {
      return await _initDatabase();
    });

    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'my_contact.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE contact(id INTEGER PRIMARY KEY, name TEXT, cellphone TEXT, telephone TEXT,  favorite INTEGER)');
      },
      version: 1,
    );
  }
}
