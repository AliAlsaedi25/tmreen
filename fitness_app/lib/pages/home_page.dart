import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

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
              'Welcome, $username',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/workouts', arguments: username);
              },
              child: Text('View My Workouts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/coaches', arguments: username);
              },
              child: Text('Browse Coaches'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/messageLog', arguments: username);
              },
              child: Text('Message Log'),
            ),
          ],
        ),
      ),
    );
  }
}
