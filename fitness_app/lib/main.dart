import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/view_workouts_page.dart';
import 'pages/workout_tracker_page.dart';
import 'pages/statistics_page.dart';
import 'pages/coach_home_page.dart';
import 'pages/moniter_clients_page.dart' as clients;
import 'pages/moniter_requests_page.dart' as requests;
import 'pages/client_workouts_page.dart';
import 'pages/coaches_page.dart';
import 'pages/coach_detail.dart';
import 'pages/message_board_page.dart';
import 'pages/message_log_page.dart';
import 'pages/coach_message_log_page.dart';
import 'pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primaryColor: Colors.blue[900], // Dark Blue
        scaffoldBackgroundColor: Colors.white, // Updated for background color
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16), // Correct text style name
          bodyMedium: TextStyle(color: Colors.black, fontSize: 14), // Correct text style name
          headlineSmall: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold), // Changed to headlineSmall
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Use primary color directly
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange, // Use colorScheme for secondary color
          primary: Colors.blue[900], // Dark Blue
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/viewWorkouts': (context) => ViewWorkoutsPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/workoutTracker': (context) => WorkoutTrackerPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/statistics': (context) => StatisticsPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/coachHome': (context) => CoachHomePage(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/monitorClients': (context) => clients.MonitorClientsPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/clientWorkouts': (context) => ClientWorkoutsPage(coachUsername: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['coachUsername'], clientUsername: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['clientUsername']),
        '/coaches': (context) => CoachesPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/monitorRequests': (context) => requests.MonitorRequestsPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/messageBoard': (context) => MessageBoardPage(clientUsername: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['clientUsername'], coachUsername: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['coachUsername']),
        '/messageLog': (context) => MessageLogPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/coachMessageLog': (context) => CoachMessageLogPage(username: ModalRoute.of(context)!.settings.arguments as String),
        '/signup': (context) => SignUpPage(),
        '/coachDetail': (context) => CoachDetailPage(coach: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>, clientUsername: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['clientUsername']),
      },
    );
  }
}
