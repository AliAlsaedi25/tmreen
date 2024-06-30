import 'package:flutter/material.dart';
import 'view_workouts_page.dart';
import 'coaches_page.dart';
import 'workout_tracker_page.dart';
import 'statistics_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated for four tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Home'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'View My Workouts'),
            Tab(text: 'Browse Coaches'),
            Tab(text: 'Workout Tracker'), // New Tab
            Tab(text: 'Statistics'), // New Tab
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ViewWorkoutsPage(username: widget.user['username']),
          CoachesPage(username: widget.user['username']),
          WorkoutTrackerPage(username: widget.user['username']), // New Page
          StatisticsPage(username: widget.user['username']), // New Page
        ],
      ),
    );
  }
}
