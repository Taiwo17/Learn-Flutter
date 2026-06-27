import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // Variable
  int _counter = 0;

  // Methods
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // UI (user interface)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // message
            Text('You pushed this button many times'),

            // Counter value
            Text(
              _counter.toString(),
              style: TextStyle(fontSize: 40),
            ),

            // Button
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
