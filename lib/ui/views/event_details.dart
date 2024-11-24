import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/source/pocketbase/client.dart';
import '../widgets/records_mixin.dart';
import 'wish_list.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.event});

  final RecordModel event;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with SignalsMixin<EventDetails>, RecordsMixin<EventDetails> {
  late final description = widget.event.getStringValue('description');

  @override
  String get collection => 'event_pairings';

  @override
  String? get expand => 'to';

  @override
  String? get filter => "from = '${auth$()!.id}'";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.getStringValue('name')),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            if (loading())
              const SliverToBoxAdapter(child: LinearProgressIndicator()),
            if (description.isNotEmpty)
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: HtmlWidget(
                    description,
                    onTapUrl: launchUrlString,
                    renderMode: RenderMode.column,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: () {
                if (records.isEmpty) {
                  return const Center(
                    child: Text('No pairings found'),
                  );
                }
                final pairing = records.firstOrNull;
                if (pairing == null) {
                  return const Center(
                    child: Text('Pairing does not exist!'),
                  );
                }
                final to = pairing.expand['to']?.firstOrNull;
                if (to == null) {
                  return const Center(
                    child: Text('User not found!'),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('You got: ${to.getStringValue('name')}!'),
                      const SizedBox(height: 10),
                      FilledButton(
                        child: const Text('View Wish List'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WishList(user: to),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
