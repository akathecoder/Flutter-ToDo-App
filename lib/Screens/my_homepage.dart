import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/Screens/add_item_page.dart';
import 'package:flutter_todo_app/Screens/login_page.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';
import 'package:flutter_todo_app/utilities/firebase_firestore.dart';
import 'package:flutter_todo_app/utilities/todo_item.dart';

class MyHomePage extends StatefulWidget {
  static String id = "homePage";

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? loginedUser;
  List<ToDoItem> todoItems = [];

  @override
  void initState() {
    super.initState();

    getLoginedUser().then(
      (value) {
        if (value != null) {
          loginedUser = value;
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginPage.id, (_) => false);
        }
      },
    );

    getItems().then((items) {
      items!.sort((a, b) => a.data().id.compareTo(b.data().id));

      for (var e in items) {
        todoItems.add(ToDoItem(
          id: e.data().id,
          title: e.data().title,
          information: e.data().information,
          complete: e.data().complete,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        loginedUser = user;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: "Logout",
            onPressed: () {
              logoutUser();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (_) => false);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: CheckboxListTile(
                title: Text(todoItems[index].title),
                subtitle: Text(todoItems[index].information),
                value: todoItems[index].complete,
                onChanged: (_) {},
                controlAffinity: ListTileControlAffinity.leading,
                checkboxShape: const CircleBorder(),
                secondary: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  splashColor: Colors.red,
                  tooltip: "Delete",
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddItemPage.id);
        },
        tooltip: "Add Item",
        elevation: 10,
        child: const Icon(Icons.add),
      ),
    );
  }
}
