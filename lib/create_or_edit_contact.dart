import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_contact_app/contact_item.dart';
import 'package:my_contact_app/contact_repository.dart';
import 'package:provider/provider.dart';

import 'contacts_list.dart';

class CreateOrEditContact extends StatefulWidget {
  ContactItem? contactItem;

  CreateOrEditContact({super.key, this.contactItem});

  @override
  State<StatefulWidget> createState() {
    return CreateOrEditContactState();
  }
}

class CreateOrEditContactState extends State<CreateOrEditContact> {
  late final TextEditingController _nameInputController;
  late final TextEditingController _cellphoneInputController;
  late final TextEditingController _telephoneInputController;
  bool favorite = false;

  List<ImageObject> _avatar = [];

  late final ContactList _contactList;

  @override
  Widget build(BuildContext context) {
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.orange;
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add New Contact'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: favorite
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border),
              onPressed: () {
                setState(() {
                  favorite = !favorite;
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              Center(
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      final List<ImageObject> imageObjects =
                          await Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, __) {
                        return const ImagePicker(
                          maxCount: 1,
                        );
                      }));

                      if (imageObjects.isNotEmpty) {
                        setState(() {
                          _avatar = imageObjects;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundImage: _avatar.isNotEmpty
                            ? Image.file(File(_avatar[0].modifiedPath)).image
                            : Image.asset('assets/images/default.png').image,
                        radius: 38,
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80, right: 20, left: 20),
                child: TextField(
                  controller: _nameInputController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(20.0),
                    icon: Icon(Icons.person),
                    labelText: 'Full Name',
                  ),
                  autofocus: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                  controller: _cellphoneInputController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(20.0),
                    icon: Icon(Icons.phone_android),
                    labelText: 'Cellphone Number',
                  ),
                  autofocus: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                  controller: _telephoneInputController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(20.0),
                    icon: Icon(Icons.phone),
                    labelText: 'Telephone Number',
                  ),
                  autofocus: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150, right: 20, left: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (_nameInputController.text.isEmpty ||
                            _cellphoneInputController.text.isEmpty ||
                            _telephoneInputController.text.isEmpty) {
                          showSnackbar('Please check the inputs');
                        } else {
                          ContactItem contactItem = ContactItem(
                              id: 0,
                              name: _nameInputController.text,
                              cellphone: _cellphoneInputController.text,
                              telephone: _telephoneInputController.text,
                              avatar: _avatar.isNotEmpty ? _avatar[0].modifiedPath : 'assets/images/default.png',
                              favorite: favorite);
                          int result = await ContactRepository().insert(
                              contactItem);
                          if (context.mounted) {
                            if (result > 0) {
                              _contactList.insert(result, contactItem);
                              Navigator.of(context).pop();
                            } else {
                              showSnackbar('Failed to insert contact');
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    _contactList = Provider.of<ContactList>(context, listen: false);

    super.initState();

    _nameInputController = TextEditingController();
    _cellphoneInputController = TextEditingController();
    _telephoneInputController = TextEditingController();
  }

  showSnackbar(String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
