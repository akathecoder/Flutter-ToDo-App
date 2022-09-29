import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/Screens/my_homepage.dart';
import 'package:flutter_todo_app/utilities/firebase_auth.dart';
import 'package:flutter_todo_app/utilities/validation.dart';

class SignUpPage extends StatefulWidget {
  static String id = "signUpPage";

  const SignUpPage({super.key});

  final String title = "Sign Up";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                        keyboardType: TextInputType.emailAddress,
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
                        // obscureText: true,
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
                        keyboardType: TextInputType.text,
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
                            _formKey.currentState?.save();
                            createUserWithEmailAndPassword(
                              emailAddress: emailAddress,
                              password: password,
                            ).then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, MyHomePage.id, (_) => false);
                            });
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
