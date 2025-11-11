import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:intl/intl.dart';

import 'model/chart_data.dart';

class PriceChart extends StatelessWidget {
  final List<ChartData> chartData;
  final String timeframe;

  const PriceChart({
    super.key,
    required this.chartData,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return Center(
        child: Text('No chart data available'),
      );
    }

    final spots = chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final minY = chartData.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxY = chartData.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    final isPositive = chartData.last.price >= chartData.first.price;

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                    final time = chartData[value.toInt()].time;
                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('HH:mm').format(time),
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: minY - padding,
          maxY: maxY + padding,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: isPositive ? Colors.green : Colors.red,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final time = chartData[spot.x.toInt()].time;
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(2)}\n${DateFormat('HH:mm').format(time)}',
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}