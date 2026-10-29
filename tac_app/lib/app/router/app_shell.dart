import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tac_app/core/utils/toast.dart';

/// Bottom navigation: Home · My rides · Messages · Profile.
/// Messages has no branch; it shows a "not in POC" toast.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _messagesTab = 2;

  /// Branch index → tab index (Messages sits between My rides and Profile).
  int get _selectedTab => navigationShell.currentIndex < _messagesTab ? navigationShell.currentIndex : 3;

  void _onTab(int tab) {
    if (tab == _messagesTab) {
      showToast('Messages are not in the POC yet.');
      return;
    }
    final branch = tab < _messagesTab ? tab : tab - 1;
    navigationShell.goBranch(branch, initialLocation: branch == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: _onTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car),
            label: 'My rides',
          ),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
