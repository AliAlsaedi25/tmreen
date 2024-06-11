import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> user;

  HomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, ${user['name']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/workouts', arguments: user['username']);
              },
              child: Text('View My Workouts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/coaches', arguments: user['username']);
              },
              child: Text('Browse Coaches'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/messageLog', arguments: user['username']);
              },
              child: Text('Message Log'),
            ),
          ],
        ),
      ),
    );
  }
}
