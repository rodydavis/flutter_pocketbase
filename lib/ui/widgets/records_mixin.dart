import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';

import '../../data/source/pocketbase/client.dart';

mixin RecordsMixin<T extends StatefulWidget> on SignalsMixin<T> {
  String get collection;
  String? get filter => null;
  String? get expand => null;

  late final records = createListSignal<RecordModel>([]);
  late final loading = this.createSignal(false);
  final cleanup = <VoidCallback>{};
  late final col = pocketbase$().collection(collection);

  Future<void> refresh() async {
    try {
      loading.value = true;
      records.value = await col.getFullList(
        filter: filter,
        expand: expand,
      );
    } catch (e) {
      debugPrint('error: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> init() async {
    await refresh();
    final dispose = await col.subscribe('*', (e) {
      final record = e.record;
      if (record == null) return;
      switch (e.action) {
        case 'create':
        case 'update':
          final idx = records.indexWhere((r) => r.id == record.id);
          if (idx != -1) {
            records[idx] = record;
          } else {
            records.add(record);
          }
          break;
        case 'delete':
          final idx = records.indexWhere((r) => r.id == record.id);
          if (idx != -1) records.removeAt(idx);
          break;
        default:
      }
    });
    cleanup.add(dispose);
  }

  @override
  void initState() {
    super.initState();
    init().ignore();
  }

  @override
  void dispose() {
    for (final cb in cleanup) {
      cb();
    }
    super.dispose();
  }
}
