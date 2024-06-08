import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'coach_detail.dart'; // Import Coach Detail Page

class CoachesPage extends StatelessWidget {
  final String username;

  CoachesPage({required this.username});

  Future<List<dynamic>> _loadCoaches() async {
    final jsonString = await rootBundle.loadString('assets/coaches.json');
    final List<dynamic> coaches = json.decode(jsonString);
    return coaches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Coaches'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadCoaches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No coaches available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final coach = snapshot.data![index];
                return ListTile(
                  title: Text(coach['name']),
                  subtitle: Text(coach['about']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachDetailPage(coach: coach, clientUsername: username),
                      ),
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
