import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository/scheme_repository.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/notifications_screen.dart';

class YojanaLabhApp extends StatelessWidget {
  const YojanaLabhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => SchemeRepository(),
      child: MaterialApp(
        title: 'योजनालाभ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'होम',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'सूचनाएं',
          ),
        ],
      ),
    );
  }
}
