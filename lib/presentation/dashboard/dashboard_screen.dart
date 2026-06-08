import 'package:flutter/material.dart';
import 'weather_widget.dart';
import 'recommendation_card.dart';
import 'trend_row.dart';

class DashboardScreen extends StatelessWidget {
  final Function(String) onNavigate;
  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('Welcome Style Hub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const WeatherWidget(),
            const SizedBox(height: 16),
            const RecommendationCard(),
            const SizedBox(height: 24),
            const Text('Trending Layout Feeds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TrendRow(onTrendTap: (trend) => onNavigate('trend_detail_$trend')),
          ],
        ),
      ),
    );
  }
}