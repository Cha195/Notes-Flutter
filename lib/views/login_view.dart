import 'package:flutter/material.dart';
import 'package:test_app/constants/routes.dart';
import 'package:test_app/services/auth/auth_exceptions.dart';
import 'package:test_app/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login")),
      body: Center(
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
                  await AuthService.firebase()
                      .logIn(email: emailValue, password: passwordValue);
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/$notesRoute', (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/$baseRoute', (route) => false);
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'User Not Found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'Password is wrong');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication Error');
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/$registerRoute', (route) => false);
                },
                child: const Text("Don't have an account? Register"))
          ],
        ),
      ),
    );
  }
}
