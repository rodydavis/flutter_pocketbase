import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';

import '../../data/source/pocketbase/client.dart';

mixin RecordMixin<T extends StatefulWidget> on SignalsMixin<T> {
  String get collection;
  String get id;
  String? get expand => null;

  late final record = this.createSignal<RecordModel?>(null);
  late final loading = this.createSignal(false);
  final cleanup = <VoidCallback>{};
  late final col = pocketbase$().collection(collection);

  Future<void> refresh() async {
    try {
      loading.value = true;
      record.value = await col.getOne(
        id,
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
    final dispose = await col.subscribe(id, (e) {
      final record = e.record;
      if (record == null) return;
      switch (e.action) {
        case 'create':
        case 'update':
          if (id == record.id) {
            this.record.value = record;
          }
          break;
        case 'delete':
          if (id == record.id) {
            this.record.value = null;
          }
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
