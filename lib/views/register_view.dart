import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/constants/routes.dart';
import 'package:test_app/utilities/dialogs/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              TextField(
                  controller: _password,
                  autocorrect: false,
                  enableSuggestions: false,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password")),
              TextButton(
                onPressed: () async {
                  String emailValue = _email.text;
                  String passwordValue = _password.text;

                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailValue, password: passwordValue);
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    Navigator.of(context).pushNamed('/$baseRoute');
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      await showErrorDialog(context, 'Set a stronger Password');
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorDialog(context,
                          'This email address is associated to another account');
                    } else {
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    await showErrorDialog(context, 'Error: ${e.toString()}');
                  }
                },
                child: const Text("Register"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/$loginRoute', (route) => false);
                  },
                  child: const Text("Already have an account? Login"))
            ],
          ),
        ),
      ),
    );
  }
}
