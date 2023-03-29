import 'package:my_contact_app/contact_interface.dart';
import 'package:my_contact_app/contact_item.dart';
import 'package:my_contact_app/database_manager.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository extends ContactInterface {
  @override
  Future<int> delete(ContactItem item) async {
    Database database = await DatabaseManager.instance.database;

    return database.delete("contacts", where: 'id = ?', whereArgs: [item.id]);
  }

  @override
  Future<List<ContactItem>> getAll() async {
    Database database = await DatabaseManager.instance.database;

    List<Map<String, Object?>> contacts = await database.query("contacts");

    List<ContactItem> data = List.generate(contacts.length, (index) {
      Map<String, Object?> item = contacts[index];
      return ContactItem(id: item['id'] as int,
          name: item['name'] as String,
          cellphone: item['cellphone'] as String,
          telephone: item['telephone'] as String,
          avatar: item['avatar'] as String,
          favorite: item['favorite'] as int == 1);
    });

    return data;
  }

  @override
  Future<int> insert(ContactItem item) async {
    Database database = await DatabaseManager.instance.database;
    Map<String, Object?> data = item.toMap();
    data.remove('id');

    return database.insert(
        "contacts", data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<int> update(ContactItem item) async {
    Database database = await DatabaseManager.instance.database;

    return database.update("contacts", item.toMap(), where: 'id = ?',
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}