import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'message_board_page.dart'; // Import Message Board Page

class CoachDetailPage extends StatelessWidget {
  final Map<String, dynamic> coach;
  final String clientUsername;

  CoachDetailPage({required this.coach, required this.clientUsername});

  Future<void> _sendRequest(BuildContext context) async {
    try {
      final coachesData = await _loadJsonData('assets/coaches.json');
      final selectedCoach = coachesData.firstWhere((c) => c['username'] == coach['username']);

      if (selectedCoach['requests'].contains(clientUsername)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request already sent')));
        return;
      }

      selectedCoach['requests'].add(clientUsername);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/coaches.json';
      final file = File(filePath);
      await file.writeAsString(json.encode(coachesData));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request sent')));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  Future<List<dynamic>> _loadJsonData(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  Future<List<dynamic>> _loadClients() async {
    final jsonString = await rootBundle.loadString('assets/clients.json');
    final List<dynamic> clients = json.decode(jsonString);
    return clients.where((client) => coach['clients'].contains(client['username'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coach['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(coach['about'], style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _sendRequest(context);
              },
              child: Text('Request to Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageBoardPage(clientUsername: clientUsername, coachUsername: coach['username']),
                  ),
                );
              },
              child: Text('Message Coach'),
            ),
            SizedBox(height: 16),
            Text('Clients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
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
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
