import 'package:flutter/material.dart';
import 'package:social_min_app/components/my_drawer.dart';
import 'package:social_min_app/components/my_list_tile.dart';
import 'package:social_min_app/components/my_post_button.dart';
import 'package:social_min_app/components/my_textfield.dart';
import 'package:social_min_app/database/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post if there is something in the textfield

    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('W A L L'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          // TEXTFIELD BOX FOR USER TO TYPE
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    hintText: 'Say Something',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                MyPostButton(onTap: postMessage),
              ],
            ),
          ),

          // POSTS - Reading the message back to our app
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // get all posts

              final posts = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No Post... Post something'),
                  ),
                );
              }

              // return a list

              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data for each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    // return as a list tile
                    return MyListTile(title: message, subtitle: userEmail);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
