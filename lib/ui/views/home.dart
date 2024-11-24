import 'package:flutter/material.dart';

import '../widgets/auth_guard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
        );
      },
    );
  }
}
