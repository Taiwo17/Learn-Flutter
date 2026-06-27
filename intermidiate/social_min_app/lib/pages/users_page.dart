import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_min_app/components/my_back_button.dart';
import 'package:social_min_app/components/my_list_tile.dart';
import 'package:social_min_app/helper/helper_function.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          // any errors
          if (snapshot.hasError) {
            displayMessageToUser('Something went wrong', context);
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const Text('No data');
          }

          // get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 25),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),

              // list of users
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    // get individual user
                    final user = users[index];

                    // get data from each user
                    String username = user['username'];
                    String email = user['email'];

                    return MyListTile(
                      title: username,
                      subtitle: email,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
