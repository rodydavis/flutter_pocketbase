import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';

import '../widgets/actions.dart';
import '../widgets/record_mixin.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.user,
  });

  final RecordModel user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with SignalsMixin<Profile>, RecordMixin<Profile> {
  @override
  String get id => widget.user.id;

  @override
  String get collection => 'users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: () {
        if (loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = record.value ?? widget.user;
        final name = profile.getStringValue('name');
        return ListView(
          children: [
            // Display profile information
            ListTile(
              title: Text(name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await prompt(
                    context,
                    title: 'Name',
                    value: name,
                  );
                  if (result == null) return;
                  await col.update(profile.id, body: {
                    'name': result,
                  });
                },
              ),
            ),
            ListTile(
              title: Text(profile.getStringValue('email')),
              // Do not allow changing email, gets complicated
            ),
          ],
        );
      }(),
    );
  }
}
