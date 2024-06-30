import 'package:mongo_dart/mongo_dart.dart' as mongo;

// Use the IP address 10.0.2.2 to refer to the host machine's localhost from the Android emulator
const dbConnectionString = 'mongodb://10.0.2.2:27017/tmreen';

Future<mongo.Db> connectToDb() async {
  var db = mongo.Db(dbConnectionString);
  await db.open();
  print('Connected to the database');
  return db;
}

Future<Map<String, dynamic>?> getUserByUsername(mongo.Db db, String username) async {
  var collection = db.collection('clients');
  var user = await collection.findOne(mongo.where.eq('username', username));
  return user;
}

Future<Map<String, dynamic>?> getCoachByUsername(mongo.Db db, String username) async {
  var collection = db.collection('coaches');
  var coach = await collection.findOne(mongo.where.eq('username', username));
  return coach;
}

Future<void> addUser(mongo.Db db, Map<String, dynamic> user) async {
  var collection = db.collection('clients');
  await collection.insertOne(user);
}

Future<void> addCoach(mongo.Db db, Map<String, dynamic> coach) async {
  var collection = db.collection('coaches');
  await collection.insertOne(coach);
}

Future<void> updateUserWorkouts(mongo.Db db, String username, List<Map<String, dynamic>> workouts) async {
  var collection = db.collection('clients');
  await collection.updateOne(
    mongo.where.eq('username', username),
    mongo.modify.set('workouts', workouts),
  );
}

Future<List<Map<String, dynamic>>> getAllCoaches(mongo.Db db) async {
  var collection = db.collection('coaches');
  var coaches = await collection.find().toList();
  return coaches;
}
