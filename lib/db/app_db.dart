


import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:test_sql/entity/employee_entity.dart';

part 'app_db.g.dart';//  flutter pub run build_runner build --delete-conflicting-outputs

LazyDatabase _openConnection() {
return LazyDatabase(() async {
final dbFolder = await getApplicationDocumentsDirectory();
final file = File(path.join(dbFolder.path, 'employee.sqlite'));

return NativeDatabase(file);
});
}

@DriftDatabase(tables: [Employee])
class AppDb extends _$AppDb {
AppDb() : super(_openConnection());

@override
int get schemaVersion => 1;
}
// flutter pub run build_runner build --delete-conflicting-outputs