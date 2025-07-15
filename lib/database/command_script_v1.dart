import 'package:sqflite/sqflite.dart';

import 'command_script.dart';
import 'sqlite_scheme.dart';

class CommandScriptV1 extends CommandScript {
  Future<void> execute(Batch batch) async {
    batch.execute('''
    CREATE TABLE Users(
    id INTGER  PRIMARY KEY,
    fullname TEXT,
    email TEXT,
    username Text,
    password Text
    )

    ''');
  }
}
