// User detail page stub — implementation pending.
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final String userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('User Detail: $userId')));
}
