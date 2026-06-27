import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_min_app/components/my_button.dart';
import 'package:social_min_app/components/my_textfield.dart';
import 'package:social_min_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    super.key,
    required this.onTap,
  });

  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  void register() async {
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const Center(child: CircularProgressIndicator());
      },
    );

    final email = emailController.text.trim();
    final password = passwordController.text;
    final username = usernameController.text.trim();

    if (password != confirmPwController.text) {
      if (dialogContext != null &&
          Navigator.of(dialogContext!, rootNavigator: true).canPop()) {
        Navigator.of(dialogContext!, rootNavigator: true).pop();
      }
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await createUserDocument(userCredential, username);

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

  // Creating the user and docs
  Future<void> createUserDocument(
    UserCredential userCredential,
    String username,
  ) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user!.email) // setting the docs
        // .doc(userCredential.user!.uid) // setting the docs also
        .set({
          'email': userCredential.user!.email,
          'username': username,
          'uid': userCredential.user!.uid,
        });
  }

  @override
  void dispose() {
    super.dispose();
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

              // username textfield
              MyTextfield(
                hintText: 'Username',
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

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

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextfield(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: confirmPwController,
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
              MyButton(text: 'Register', onTap: register),

              const SizedBox(height: 20),

              // don't have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login here',
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
