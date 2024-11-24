import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';

import '../widgets/records_mixin.dart';

class Counters extends StatefulWidget {
  const Counters({super.key});

  @override
  State<Counters> createState() => _CountersState();
}

class _CountersState extends State<Counters> with SignalsMixin, RecordsMixin {
  @override
  String get collection => 'counter';

  List<RecordModel> get counters => records;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counters'),
      ),
      body: () {
        if (counters.isEmpty) {
          return const Center(
            child: Text('No Counters Found'),
          );
        }
        return ListView.builder(
          itemCount: counters.length,
          itemBuilder: (context, index) {
            final counter = counters[index];
            final count = counter.getIntValue('count');
            return ListTile(
              title: Text('Counter: $count'),
              leading: IconButton(
                onPressed: () async {
                  await col.delete(counter.id);
                },
                icon: const Icon(Icons.delete_forever),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await col.update(counter.id, body: {
                        'count': count + 1,
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      await col.update(counter.id, body: {
                        'count': count - 1,
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            );
          },
        );
      }(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await col.create(body: {'count': 0});
        },
      ),
    );
  }
}
