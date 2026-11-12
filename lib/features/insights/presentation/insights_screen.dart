import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights & Summaries'),
      ),
      body: const Center(
        child: Text('Monthly Income, Expenses & Category Breakdown'),
      ),
    );
  }
}

