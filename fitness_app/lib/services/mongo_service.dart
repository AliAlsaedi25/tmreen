import 'package:mongo_dart/mongo_dart.dart' as mongo;

// Database connection string
const dbConnectionString = 'mongodb://10.0.2.2:27017/tmreen';

// Function to connect to the database
Future<mongo.Db> connectToDb() async {
  var db = mongo.Db(dbConnectionString);
  try {
    await db.open();
    print('Connected to the database');
  } catch (e) {
    print('Error connecting to the database: $e');
  }
  return db;
}

// Function to get all users from the 'clients' collection
Future<List<Map<String, dynamic>>> getAllUsers(mongo.Db db) async {
  var collection = db.collection('clients');
  var users = await collection.find().toList();
  return users;
}

// Function to add a new user to the 'clients' collection
Future<void> addUser(mongo.Db db, Map<String, dynamic> user) async {
  var collection = db.collection('clients');
  await collection.insertOne(user);
}

// Function to get a user by username from the 'clients' collection
Future<Map<String, dynamic>?> getUserByUsername(mongo.Db db, String username) async {
  var collection = db.collection('clients');
  var user = await collection.findOne({'username': username});
  return user;
}

// Function to get all coaches from the 'coaches' collection
Future<List<Map<String, dynamic>>> getAllCoaches(mongo.Db db) async {
  var collection = db.collection('coaches');
  var coaches = await collection.find().toList();
  return coaches;
}

// Function to add a new coach to the 'coaches' collection
Future<void> addCoach(mongo.Db db, Map<String, dynamic> coach) async {
  var collection = db.collection('coaches');
  await collection.insertOne(coach);
}

// Function to get a coach by username from the 'coaches' collection
Future<Map<String, dynamic>?> getCoachByUsername(mongo.Db db, String username) async {
  var collection = db.collection('coaches');
  var coach = await collection.findOne({'username': username});
  return coach;
}

// Function to add a request to a coach's requests array
Future<void> addRequestToCoach(mongo.Db db, String coachUsername, String clientUsername) async {
  var coach = await getCoachByUsername(db, coachUsername);
  if (coach != null) {
    coach['requests'].add(clientUsername);
    var collection = db.collection('coaches');
    await collection.updateOne(
      mongo.where.eq('username', coachUsername),
      mongo.modify.set('requests', coach['requests']),
    );
  }
}
