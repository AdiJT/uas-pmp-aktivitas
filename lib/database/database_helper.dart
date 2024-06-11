import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String _databasePath = "app.db";

String activityTable = 'activity';
String scheduleTable = 'schedule';

Database? _db;
Future<Database> get dbInstance async {
  _db ??= await initDatabase();

  return _db!;
}

Future<Database> initDatabase() async {
  final root = await getDatabasesPath();
  final path = join(root, _databasePath);

  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE $activityTable 
        (
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          description TEXT, 
          date TEXT, 
          duration INTEGER, 
          isDone INTEGER
        )'''
      );

      await db.execute(
        '''
        CREATE TABLE $scheduleTable
        (
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          description TEXT, 
          day INTEGER, 
          time TEXT, 
          duration INTEGER
        )'''
      );
    },
  );
} 