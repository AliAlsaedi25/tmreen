import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MonitorRequestsPage extends StatelessWidget {
  final String username;

  MonitorRequestsPage({required this.username});

  Future<List<dynamic>> _loadRequests() async {
    final jsonString = await rootBundle.loadString('assets/coaches.json');
    final List<dynamic> coaches = json.decode(jsonString);
    final coach = coaches.firstWhere((coach) => coach['username'] == username);
    return coach['requests'];
  }

  Future<void> _approveRequest(String clientUsername) async {
    try {
      final coachesData = await _loadJsonData('assets/coaches.json');
      final clientsData = await _loadJsonData('assets/clients.json');
      final coachIndex = coachesData.indexWhere((coach) => coach['username'] == username);
      final clientIndex = clientsData.indexWhere((client) => client['username'] == clientUsername);

      if (coachIndex == -1 || clientIndex == -1) {
        throw Exception('Coach or Client not found');
      }

      // Add client to coach's clients array
      coachesData[coachIndex]['clients'].add(clientUsername);
      // Remove client from coach's requests array
      coachesData[coachIndex]['requests'].remove(clientUsername);

      // Save updated coaches data
      final directory = await getApplicationDocumentsDirectory();
      var filePath = '${directory.path}/coaches.json';
      var file = File(filePath);
      await file.writeAsString(json.encode(coachesData));

      // Save updated clients data
      filePath = '${directory.path}/clients.json';
      file = File(filePath);
      await file.writeAsString(json.encode(clientsData));

      print('Request approved and client moved to coach\'s clients array');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<dynamic>> _loadJsonData(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor Requests'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final request = snapshot.data![index];
                return ListTile(
                  title: Text(request),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _approveRequest(request);
                    },
                    child: Text('Approve'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
