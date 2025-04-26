import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color textColor;
  final double percentChange;
  final bool isPositiveChange;

  MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
    this.percentChange = 0.0,
    this.isPositiveChange = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: isPositiveChange ? Colors.green : Colors.red,
              ),
              SizedBox(width: 5),
              Text(
                '${percentChange.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isPositiveChange ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
