class UserTable {
  static const tableName = 'users';

  static const createTable =
      '''
    CREATE TABLE $tableName (
      id TEXT PRIMARY KEY,
      full_name TEXT,
      email TEXT,
      phone TEXT,
      address TEXT
    )
  ''';

  static const insert =
      '''
    INSERT INTO $tableName(id, full_name, email, phone, address)
    VALUES (?, ?, ?, ?, ?)
  ''';

  static const selectAll =
      '''
    SELECT * FROM $tableName
  ''';

  static const deleteAll =
      '''
    DELETE FROM $tableName
  ''';
}
