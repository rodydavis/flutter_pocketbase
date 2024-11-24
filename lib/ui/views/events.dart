import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../widgets/records_mixin.dart';
import 'event_details.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events>
    with SignalsMixin<Events>, RecordsMixin<Events> {
  @override
  String get collection => 'events';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          if (loading()) const LinearProgressIndicator(),
          Expanded(
            child: () {
              if (records.isEmpty) {
                return const Center(
                  child: Text('No events found'),
                );
              }
              final size = MediaQuery.sizeOf(context);
              const tileSize = 200.0;
              final count = (size.width ~/ tileSize).ceil();
              return GridView.count(
                crossAxisCount: count,
                children: [
                  for (final record in records)
                    Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetails(event: record),
                          ),
                        ),
                        child: Center(
                          child: Text(record.getStringValue('name')),
                        ),
                      ),
                    ),
                ],
              );
            }(),
          ),
        ],
      ),
    );
  }
}
