import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:signals/signals_flutter.dart';

import '../../data/source/pocketbase/client.dart';
//import '../widgets/actions.dart';
import '../widgets/records_mixin.dart';

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
    with SignalsMixin<Profile>, RecordsMixin<Profile> {
  // ... (other code)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<List<RecordModel>>(
        stream: records, // Use the records signal
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final profile = snapshot.data!.first as Profile; // Cast to your model
            return ListView(
              children: [
                // Display profile information
                ListTile(
                  title: Text(record.getStringValue('name')),
                ),
                ListTile(
                  title: Text(profile.getStringValue('email')),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}