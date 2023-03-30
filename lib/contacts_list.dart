
import 'package:flutter/material.dart';
import 'package:my_contact_app/contact_item.dart';

import 'contact_repository.dart';

class ContactList with ChangeNotifier {
  final List<ContactItem> myContacts = <ContactItem>[];

  final List<ContactItem> myFavoriteContacts = <ContactItem>[];

  void initMyContacts(List<ContactItem> contacts) {
    myContacts.clear();
    myFavoriteContacts.clear();

    myContacts.addAll(contacts);

    myContacts.sort((a, b) => a.name.compareTo(b.name));

    myFavoriteContacts.addAll(myContacts.where((element) => element.favorite).toList());
    myFavoriteContacts.sort((a, b) => a.name.compareTo(b.name));

    notifyListeners();
  }

  void getAllContacts() async {
    List<ContactItem> contacts = await ContactRepository().getAll();
    initMyContacts(contacts);
  }

  void insert(int index, ContactItem contact) {
    ContactItem newItem = ContactItem(id: index,
        name: contact.name,
        cellphone: contact.cellphone,
        telephone: contact.telephone,
        avatar: contact.avatar,
        favorite: contact.favorite);

    myContacts.add(newItem);
    myContacts.sort((a, b) => a.name.compareTo(b.name));

    if (newItem.favorite) {
      myFavoriteContacts.add(newItem);
      myFavoriteContacts.sort((a, b) => a.name.compareTo(b.name));
    }

    notifyListeners();
  }

  void update(ContactItem newItem) {
    var index = myContacts.indexWhere((element) => element.id == newItem.id);
    myContacts[index] = newItem;

    myContacts.sort((a, b) => a.name.compareTo(b.name));

    if (newItem.favorite) {
      var index = myFavoriteContacts.indexWhere((element) => element.id == newItem.id);

      if (index >= 0) {
        myFavoriteContacts[index] = newItem;
      } else {
        myFavoriteContacts.add(newItem);
      }

      myFavoriteContacts.sort((a, b) => a.name.compareTo(b.name));
    }

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