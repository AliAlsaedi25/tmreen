import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/workouts_page.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(user: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>),
        '/workouts': (context) => WorkoutsPage(username: ModalRoute.of(context)!.settings.arguments as String),
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
