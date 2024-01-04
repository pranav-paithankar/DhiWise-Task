import 'package:dhiwise_task/goals_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // Define your pages or screens here
  final List<Widget> _pages = [
    GoalScreen(),
    GoalScreen(),
    GoalScreen(),
    GoalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor: const Color.fromARGB(255, 12, 58, 95), // Active color
      unselectedItemColor: Colors.grey, // Inactive color
      showSelectedLabels: false, // Hide labels for selected item
      showUnselectedLabels: false, // Hide labels for unselected items
      items: [
        buildBottomNavigationBarItem(Icons.home),
        buildBottomNavigationBarItem(Icons.autorenew),
        buildBottomNavigationBarItem(Icons.auto_mode),
        buildBottomNavigationBarItem(Icons.settings),
      ],
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 35,
      ),
      label: '', // Empty label to hide it
    );
  }
}
