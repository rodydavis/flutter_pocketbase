import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals/signals.dart';

import '../http_client/client.dart';

final auth$ = Signal<RecordModel?>(null);
final pocketbase$ = Signal<PocketBase>.lazy();

Future<PocketBase> createPocketBase() async {
  final prefs = await SharedPreferences.getInstance();
  const authKey = 'auth';
  final token = prefs.getString(authKey);
  final store = AsyncAuthStore(
    initial: token,
    save: (token) async {
      await prefs.setString(authKey, token);
    },
    clear: () async {
      await prefs.remove(authKey);
    },
  );
  
  void update(dynamic model) {
    if (model is RecordModel) {
      auth$.value = model;
    } else {
      auth$.value = null;
    }
  }

  store.onChange.listen((event) {
    final model = event.record;
    update(model);
  });
 
  final pb = PocketBase(
    'http://127.0.0.1:8090',
    httpClientFactory: createHttpClient,
    authStore: store,
  );
  
  if (token != null) {
    // Try to refresh auth
    pb.collection('users').authRefresh().ignore();
  }
  
  final model = store.record;
  update(model);
  return pb;
}
