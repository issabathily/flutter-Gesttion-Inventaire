import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:retail_app/utils/constants.dart';

class SalesChart extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  SalesChart({required this.salesData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: salesData.isEmpty
          ? Center(
              child: Text('Aucune donnée de vente disponible'),
            )
          : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        // Show every 5 days
                        if (value.toInt() % 5 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Format currency values
                        if (value % 100 == 0) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 32,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: 1,
                maxX: salesData.length.toDouble(),
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _createSpots(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        stops: const [0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<FlSpot> _createSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < salesData.length; i++) {
      spots.add(FlSpot(
        (i + 1).toDouble(),
        salesData[i]['amount'].toDouble(),
      ));
    }
    return spots;
  }

  double _getMaxY() {
    if (salesData.isEmpty) return 500;
    
    double maxValue = 0;
    for (var data in salesData) {
      if (data['amount'] > maxValue) {
        maxValue = data['amount'].toDouble();
      }
    }
    
    // Add 20% padding to the max value
    return maxValue > 0 ? maxValue * 1.2 : 500;
  }
}
