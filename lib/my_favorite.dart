
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'contacts_list.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final contactList = Provider.of<ContactList>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Favorite"),
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  backgroundImage: contactList.myFavoriteContacts[index].avatar
                      .startsWith('assets')
                      ? Image.asset(contactList.myFavoriteContacts[index].avatar)
                      .image
                      : Image.file(
                      File(contactList.myFavoriteContacts[index].avatar))
                      .image),
              trailing: IconButton(
                icon: contactList.myFavoriteContacts[index].favorite
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border), onPressed: () {  },
              ),
              title: Text(contactList.myFavoriteContacts[index].name),
              onTap: () {},
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: Colors.grey,
            );
          },
          itemCount: contactList.myFavoriteContacts.length),
    );
  }
}