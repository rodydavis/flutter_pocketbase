import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../data/source/pocketbase/client.dart';
import 'profile.dart';
import 'wish_list.dart';
import 'events.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SignalsMixin {
  late final index = this.createSignal(0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final tablet = size.width > 800 && size.height > 600;
    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.event),
        label: 'Events',
      ),
      NavigationDestination(
        icon: Icon(Icons.list),
        label: 'Wish List',
      ),
      NavigationDestination(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
    return Scaffold(
      body: Row(
        children: [
          if (tablet)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              selectedIndex: index.get(),
              onDestinationSelected: index.set,
              destinations: destinations.map((e) => e.toNavRail()).toList(),
            ),
          Expanded(
            child: IndexedStack(
              index: index.value,
              children: [
                const Events(),
                WishList(user: auth$()!),
                Profile(user: auth$()!),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: tablet
          ? null
          : NavigationBar(
              selectedIndex: index.get(),
              onDestinationSelected: index.set,
              destinations: destinations,
            ),
    );
  }
}

extension on NavigationDestination {
  NavigationRailDestination toNavRail() {
    return NavigationRailDestination(
      icon: icon,
      label: Text(label),
    );
  }
}
