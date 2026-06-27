import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});

  // email and password controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  void register(BuildContext context) {
    // get auth services
    final auth = AuthServices();

    // if password match, create user
    if (_confirmPwController.text == _passwordController.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Password don"t match'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 50),
            // welcome back message
            Text(
              'Let"s create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            // email textfield
            MyTextfield(
              hintText: 'Enter your email',
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 10),
            // pw textfield
            MyTextfield(
              hintText: 'Enter your password',
              obscureText: true,
              controller: _passwordController,
            ),
            SizedBox(height: 25),

            // confirm textfield
            MyTextfield(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPwController,
            ),

            SizedBox(height: 25),

            // login button
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),

            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            // register now
          ],
        ),
      ),
    );
  }
}
