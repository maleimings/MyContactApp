
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_contact_app/contact_repository.dart';
import 'package:my_contact_app/contacts_list.dart';
import 'package:provider/provider.dart';

import 'add_new_contact.dart';
import 'contact_item.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => ContactList(),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Contact'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _drawerScaffoldKey =
      GlobalKey<ScaffoldState>();

  bool isLoading = true;

  late final ContactList contactList;

  showAddNewContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewContact()),
    );
  }


  @override
  void initState() {
    contactList = Provider.of<ContactList>(context, listen: false);

    super.initState();
    getMyContacts();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: Text(
          widget.title,
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (_drawerScaffoldKey.currentState?.isDrawerOpen == true) {
              Navigator.pop(context);
            } else {
              _drawerScaffoldKey.currentState?.openDrawer();
            }
          },
        ),
      ),
      body: Scaffold(
        key: _drawerScaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: const Text('Favorites'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Create Contact'),
                  onTap: () {
                    showAddNewContact(context);
                  },
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () {},
                ),
              ],
            ).toList(),
          ),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Center(
                child: ListView.separated(
                  shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.file(File(contactList.myContacts[index].avatar)),
                        title: Text(contactList.myContacts[index].name),
                        onTap: () {

                        },);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                    return const Divider(color: Colors.grey,);
                    },
                    itemCount: contactList.myContacts.length),
              ),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
              )
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddNewContact(context);
          },
          tooltip: 'Create new contact',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getMyContacts() async {
    List<ContactItem> contacts = await ContactRepository().getAll();
    contactList.initMyContacts(contacts);
    setState(() {
      isLoading = false;
    });
  }
}
