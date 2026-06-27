import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_min_app/components/my_back_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email) // getting the docs
        // .doc(currentUser!.uid) // getting the docs also
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   elevation: 0,
      // ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // error...
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          // data received
          else if (snapshot.hasData) {
            // extra data
            Map<String, dynamic>? user = snapshot.data!.data();

            return SafeArea(
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 25),
                      child: Row(
                        children: [
                          MyBackButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // profile pic
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Icon(
                        Icons.person,
                        size: 64,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // username
                    Text(
                      user!['username'] ?? "No Name",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email
                    Text(
                      user['email'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Text('No data');
          }
        },
      ),
    );
  }
}
