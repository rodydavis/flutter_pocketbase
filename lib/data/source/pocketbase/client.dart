import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

import '../http_client/client.dart';

final auth$ = Signal<RecordModel?>(null);

Future<PocketBase> createPocketBase() async {
  final prefs = await SharedPreferences.getInstance();
  const authKey = 'auth';
  final store = AsyncAuthStore(
    initial: prefs.getString(authKey),
    save: (token) async {
      await prefs.setString(authKey, token);
    },
    clear: () async {
      await prefs.remove(authKey);
    },
  );
  store.onChange.listen((event) {
    final model = event.model;
    if (model is RecordModel) {
      auth$.value = model;
    } else {
      auth$.value = null;
    }
  });
  return PocketBase(
    'http://127.0.0.1:8090',
    httpClientFactory: createHttpClient,
    authStore: store,
  );
}

final pocketbase$ = Signal<PocketBase>.lazy();
