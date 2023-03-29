
import 'package:my_contact_app/contact_item.dart';

abstract class ContactInterface {
  Future<List<ContactItem>> getAll();

  Future<int> insert(ContactItem item);

  Future<int> delete(ContactItem item);

  Future<int> update(ContactItem item);
}