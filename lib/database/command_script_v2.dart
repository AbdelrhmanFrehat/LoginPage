import 'package:sqflite/sqflite.dart';

import 'command_script.dart';
import 'sqlite_scheme.dart';

class CommandScriptV1 extends CommandScript {
  Future<void> execute(Batch batch) async {
    batch.execute("ALTER TABLE Users ADD COLUMN phoneNumber TEXT");
  }
}
