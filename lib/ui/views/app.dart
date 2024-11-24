import 'package:flutter/material.dart';

import '../widgets/auth_guard.dart';
import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: AuthGuard(
        builder: (context) {
          return const Home();
        },
      ),
    );
  }
}
