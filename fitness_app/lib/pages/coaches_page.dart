import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';
import 'coach_detail.dart';

class CoachesPage extends StatefulWidget {
  final String username;

  CoachesPage({required this.username});

  @override
  _CoachesPageState createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  late Future<List<Map<String, dynamic>>> _coaches;

  @override
  void initState() {
    super.initState();
    _coaches = _fetchCoaches();
  }

  Future<List<Map<String, dynamic>>> _fetchCoaches() async {
    var db = await connectToDb();
    var coaches = await getAllCoaches(db);
    await db.close();
    return coaches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Coaches'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _coaches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No coaches found.'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of tiles per row
                childAspectRatio: 3 / 2, // Aspect ratio for the tiles
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var coach = snapshot.data![index];
                return CoachTile(coach: coach, clientUsername: widget.username);
              },
            );
          }
        },
      ),
    );
  }
}

class CoachTile extends StatelessWidget {
  final Map<String, dynamic> coach;
  final String clientUsername;

  CoachTile({required this.coach, required this.clientUsername});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoachDetailPage(
              coach: coach,
              clientUsername: clientUsername,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  coach['name'][0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                coach['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
