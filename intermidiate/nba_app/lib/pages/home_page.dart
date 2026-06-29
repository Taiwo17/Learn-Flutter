import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/models/team_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '53a8736e-2e34-4347-8870-d7d995dd3d5d';

  // List of the team
  final List<Team> teams = [];

  Future getTeams() async {
    try {
      final url = Uri.parse('https://api.balldontlie.io/v1/teams');
      final response = await http.get(url, headers: {'Authorization': apiKey});
      final jsonData = jsonDecode(response.body);

      for (var eachTeam in jsonData['data']) {
        final team = Team(
          abbreviation: eachTeam['abbreviation'],
          city: eachTeam['city'],
        );
        teams.add(team);
      }
    } catch (e) {
      print('Error has occured $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          // is it done loading? then show the team data

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10, left: 25, right: 25),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: ListTile(
                    title: Text(teams[index].abbreviation),
                    subtitle: Text(teams[index].city),
                  ),
                );
              },
            );
          }
          // if it's still loading, show loading circle
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
