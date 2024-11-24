import 'package:flutter/material.dart';

import 'data/source/pocketbase/client.dart';
import 'ui/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pocketbase$.value = await createPocketBase();
  runApp(const App());
}
