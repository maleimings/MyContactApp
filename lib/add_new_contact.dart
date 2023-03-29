import 'package:flutter/material.dart';

class AddNewContact extends StatefulWidget {
  const AddNewContact({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddNewContactState();
  }
}

class AddNewContactState extends State<AddNewContact> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameInputController = TextEditingController();
    final TextEditingController cellphoneInputController =
    TextEditingController();
    final TextEditingController telephoneInputController =
    TextEditingController();

    // TODO: implement build
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
              icon: const Icon(Icons.star),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 60)),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: IconButton(
                          icon: const Icon(
                            Icons.photo_camera,
                            size: 50,
                          ),
                          onPressed: () {},
                        ),
                      )),
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
                      child: const Text('Save'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

}
