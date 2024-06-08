import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'client_workouts_page.dart'; // Import the Client Workouts page

class MonitorClientsPage extends StatelessWidget {
  final String username;

  MonitorClientsPage({required this.username});

  Future<List<dynamic>> _loadClients() async {
    final coachesData = await _loadJsonData('assets/coaches.json');
    final coach = coachesData.firstWhere((coach) => coach['username'] == username);
    final clientUsernames = coach['clients'];
    
    final clientsData = await _loadJsonData('assets/clients.json');
    return clientsData.where((client) => clientUsernames.contains(client['username'])).toList();
  }

  Future<List<dynamic>> _loadJsonData(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Clients'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No clients available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final client = snapshot.data![index];
                return ListTile(
                  title: Text(client['name']),
                  subtitle: Text(client['username']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientWorkoutsPage(clientUsername: client['username'])),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
