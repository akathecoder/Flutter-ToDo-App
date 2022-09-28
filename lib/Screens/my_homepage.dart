import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/Screens/add_item_page.dart';
import 'package:flutter_todo_app/Screens/login_page.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  static String id = "homePage";

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? loginedUser;

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
      body: Container(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ListTile(
              title: Text("Title"),
              subtitle: Text("This is the subtitle"),
            );
          },
        ),
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
