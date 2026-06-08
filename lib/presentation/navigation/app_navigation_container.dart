import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../closet/closet_grid_screen.dart';
import '../chat/chat_screen.dart';
import '../planner/planner_calendar_screen.dart';
import '../profile/profile_hub_screen.dart';

class AppNavigationContainer extends StatefulWidget {
  final Function(String) onSubScreenNavigate;
  final VoidCallback onOpenStylePreference;
  const AppNavigationContainer({super.key, required this.onSubScreenNavigate, required this.onOpenStylePreference});

  @override
  State<AppNavigationContainer> createState() => _AppNavigationContainerState();
}

class _AppNavigationContainerState extends State<AppNavigationContainer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onNavigate: widget.onSubScreenNavigate),
      ClosetGridScreen(onSelectCard: (item) => widget.onSubScreenNavigate('closet_detail_$item')),
      const ChatScreen(),
      const PlannerCalendarScreen(),
      ProfileHubScreen(onSelectStylePreferences: widget.onOpenStylePreference),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (idx) => setState(() => selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Hub'),
          NavigationDestination(icon: Icon(Icons.checkroom), label: 'Closet'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'AI Chat'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Log'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}