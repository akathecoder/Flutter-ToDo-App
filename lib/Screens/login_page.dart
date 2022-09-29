import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/Screens/my_homepage.dart';
import 'package:flutter_todo_app/Screens/sign_up_page.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';
import 'package:flutter_todo_app/utilities/validation.dart';

class LoginPage extends StatefulWidget {
  static String id = "loginPage";

  const LoginPage({super.key});

  final String title = "Sign In";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String emailAddress = "";
    String password = "";

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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Icon(
              Icons.task_alt,
              size: 100,
              color: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      onSaved: (value) {
                        emailAddress = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email ID',
                        hintText: 'username@email.com',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email id';
                        } else if (!isEmailValid(value)) {
                          return 'Please enter a valid email id';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      obscureText: true,
                      onSaved: (value) {
                        password = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'your\$secretPassw0rd',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.password,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (!isPasswordValid(value)) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            signInWithEmailAndPassword(
                              emailAddress: emailAddress,
                              password: password,
                            ).then((user) {
                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid Email or Password'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, MyHomePage.id, (_) => false);
                              }
                            });
                          }
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPage.id);
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
