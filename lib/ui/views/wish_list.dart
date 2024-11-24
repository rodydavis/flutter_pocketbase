import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/link.dart';

import '../../data/source/pocketbase/client.dart';
import '../widgets/actions.dart';
import '../widgets/records_mixin.dart';

class WishList extends StatefulWidget {
  const WishList({
    super.key,
    required this.user,
  });

  final RecordModel user;

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList>
    with SignalsMixin<WishList>, RecordsMixin<WishList> {
  bool get canEdit => widget.user.id == auth$()?.id;

  @override
  String get collection => 'wish_list';

  @override
  String? get filter => "user_id = '${widget.user.id}'";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          canEdit
              ? 'Wish List'
              : '${widget.user.getStringValue('name')} Wish List',
        ),
      ),
      body: Column(
        children: [
          if (loading()) const LinearProgressIndicator(),
          Expanded(
            child: () {
              if (records.isEmpty) {
                return const Center(
                  child: Text('No items found'),
                );
              }
              return ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final link = record.getStringValue('link');
                  final name = record.getStringValue('name');
                  return ListTile(
                    title: InkWell(
                      onTap: !canEdit
                          ? null
                          : () async {
                              final result = await prompt(
                                context,
                                title: 'Item Name',
                                value: name,
                              );
                              if (result == null) return;
                              await col.update(record.id, body: {
                                'name': result,
                              });
                            },
                      child: Text(name),
                    ),
                    subtitle: InkWell(
                      onTap: !canEdit
                          ? null
                          : () async {
                              final result = await prompt(
                                context,
                                title: 'Link',
                                value: link,
                              );
                              if (result == null) return;
                              await col.update(record.id, body: {
                                'link': result,
                              });
                            },
                      child: () {
                        if (link.isEmpty) return const Text('No link added');
                        if (!canEdit) {
                          return Link(
                            uri: Uri.parse(link),
                            target: LinkTarget.blank,
                            builder: (context, click) => InkWell(
                              onTap: click,
                              child: Text(link),
                            ),
                          );
                        }
                        return Text(link);
                      }(),
                    ),
                    trailing: !canEdit
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () async {
                              await col.delete(record.id);
                            },
                          ),
                  );
                },
              );
            }(),
          ),
        ],
      ),
      floatingActionButton: !canEdit
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              onPressed: () async {
                final result = await prompt(context, title: 'Item Name');
                if (result == null) return;
                await col.create(body: {
                  'name': result,
                  'user_id': auth$()!.id,
                });
              },
            ),
    );
  }
}
