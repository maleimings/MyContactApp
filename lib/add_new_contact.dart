import 'package:flutter/material.dart';

class AddNewContact extends StatelessWidget {
  const AddNewContact({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
          )
        ],
      ),
    );
  }
}
