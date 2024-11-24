import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../data/source/pocketbase/client.dart';
import '../views/login.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (context) {
        if (auth$.value == null) return const Login();
        return builder(context);
      },
    );
  }
}
