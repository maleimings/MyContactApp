
import 'package:flutter/material.dart';
import 'package:my_contact_app/contact_item.dart';

class ContactList with ChangeNotifier {
  final List<ContactItem> myContacts = <ContactItem>[];

  final List<ContactItem> myFavoriteContacts = <ContactItem>[];

  void initMyContacts(List<ContactItem> contacts) {
    myContacts.clear();
    myFavoriteContacts.clear();

    myContacts.addAll(contacts);

    myFavoriteContacts.addAll(myContacts.where((element) => element.favorite).toList());

    notifyListeners();
  }

  void updateMyContacts(ContactItem contact) {
    var index = myContacts.indexWhere((element) => element.id == contact.id);

    if (index >= 0) {
      myContacts[index] = contact;

      var i = myFavoriteContacts.indexWhere((element) => element.id == contact.id);
      if (i >= 0) {
        myFavoriteContacts[i] = contact;
      }

      notifyListeners();
    }
  }
}