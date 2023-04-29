import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class DatabaseNotifier extends StateNotifier<Database?> {
  DatabaseNotifier() : super(null);

  Future<void> initDB() async {
    // Open the database and store the reference.
    final Database database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), notesDB),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        return await db.execute(
          'CREATE TABLE IF NOT EXISTS $tableName (id INTEGER AUTO INCREMENT PRIMARY KEY, title TEXT, content LONGTEXT, audio_path VARCHAR, is_audio BOOLEAN)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    state = database;
  }
}
