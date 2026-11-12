import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFM Dashboard'),
      ),
      body: Center(
        child: Text(
          'Total Confirmed Balance',
          style: theme.textTheme.headlineSmall,
        ),
      ),
    );
  }
}

