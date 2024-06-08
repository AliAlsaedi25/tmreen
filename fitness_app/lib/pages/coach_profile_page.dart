import 'package:flutter/material.dart';

class CoachProfilePage extends StatelessWidget {
  final Map<String, dynamic> coach;

  const CoachProfilePage({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coach['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(coach['about']),
            const SizedBox(height: 20),
            const Text(
              'Clients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: coach['clients'].length,
              itemBuilder: (context, index) {
                final client = coach['clients'][index];
                return ListTile(
                  title: Text(client),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
