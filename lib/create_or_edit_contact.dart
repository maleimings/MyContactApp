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

    var favorite = widget.contactItem?.favorite ?? false;

    TextEditingController nameInputController = TextEditingController(
        text: widget.contactItem?.name.isNotEmpty == true
            ? widget.contactItem!.name
            : '');
    TextEditingController cellphoneInputController = TextEditingController(
        text: widget.contactItem?.cellphone.isNotEmpty == true
            ? widget.contactItem!.cellphone
            : '');
    TextEditingController telephoneInputController = TextEditingController(
        text: widget.contactItem?.telephone.isNotEmpty == true
            ? widget.contactItem!.telephone
            : '');

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: widget.contactItem == null
              ? const Text('Add New Contact')
              : Text(widget.contactItem?.name ?? 'Update'),
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
                        backgroundImage: widget.contactItem == null
                            ? (_avatar.isNotEmpty
                                ? Image.file(File(_avatar[0].modifiedPath))
                                    .image
                                : Image.asset('assets/images/default.png')
                                    .image)
                            : (widget.contactItem!.avatar.startsWith('assets')
                                ? Image.asset(widget.contactItem!.avatar).image
                                : Image.file(File(widget.contactItem!.avatar))
                                    .image),
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
                  controller: nameInputController,
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
                  controller: cellphoneInputController,
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
                  controller: telephoneInputController,
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
                      child: widget.contactItem == null
                          ? const Text('Save')
                          : const Text('Update'),
                      onPressed: () async {
                        if (nameInputController.text.isEmpty ||
                            cellphoneInputController.text.isEmpty ||
                            telephoneInputController.text.isEmpty) {
                          showSnackbar('Please check the inputs');
                        } else {
                          ContactItem contactItem = ContactItem(
                              id: 0,
                              name: nameInputController.text,
                              cellphone: cellphoneInputController.text,
                              telephone: telephoneInputController.text,
                              avatar: _avatar.isNotEmpty
                                  ? _avatar[0].modifiedPath
                                  : 'assets/images/default.png',
                              favorite: favorite);
                          int result = -1;
                          if (widget.contactItem == null) {
                            result =
                                await ContactRepository().insert(contactItem);
                          } else {
                            result =
                                await ContactRepository().update(contactItem);
                          }
                          result =
                              await ContactRepository().insert(contactItem);
                          if (context.mounted) {
                            if (result > 0) {
                              if (widget.contactItem == null) {
                                _contactList.insert(result, contactItem);
                              } else {
                                _contactList.update(contactItem);
                              }
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
  }

  showSnackbar(String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
