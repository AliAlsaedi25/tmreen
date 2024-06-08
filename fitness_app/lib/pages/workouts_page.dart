import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WorkoutsPage extends StatelessWidget {
  final String username;

  WorkoutsPage({required this.username});

  Future<List<dynamic>> _loadClientWorkouts() async {
    final jsonString = await rootBundle.loadString('assets/clients.json');
    final List<dynamic> clients = json.decode(jsonString);
    final client = clients.firstWhere((client) => client['username'] == username);
    return client['workouts'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts Page'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadClientWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No workouts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
