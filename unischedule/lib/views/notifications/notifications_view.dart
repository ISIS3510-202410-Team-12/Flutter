import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO implement this view
    return TextButton(
      onPressed: () => throw Exception(),
      child: const Text('Throw Test Exception to Firebase'),
    );
  }
}