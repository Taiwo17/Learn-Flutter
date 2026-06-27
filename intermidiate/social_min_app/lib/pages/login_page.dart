import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_min_app/components/my_button.dart';
import 'package:social_min_app/components/my_textfield.dart';
import 'package:social_min_app/helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});

  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login() async {
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (dialogContext != null &&
          Navigator.of(dialogContext!, rootNavigator: true).canPop()) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (dialogContext != null &&
          Navigator.of(dialogContext!, rootNavigator: true).canPop()) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }

      if (!mounted) return;
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 25),

              // app name
              Text(
                'M I N I M A L',
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextfield(
                hintText: 'Email',
                obscureText: false,
                controller: emailController,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextfield(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),

              // forgot password
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forget Password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // sign in button
              MyButton(text: 'Login', onTap: login),

              const SizedBox(height: 20),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
