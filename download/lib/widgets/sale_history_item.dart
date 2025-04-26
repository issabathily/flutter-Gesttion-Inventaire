import 'package:flutter/material.dart';
import 'package:retail_app/models/sale.dart';
import 'package:retail_app/utils/constants.dart';

class SaleHistoryItem extends StatelessWidget {
  final Sale sale;

  SaleHistoryItem({required this.sale});

  @override
  Widget build(BuildContext context) {
    // Format date for display
    final dateParts = sale.date.split('-');
    final formattedDate = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
    
    // Get percentage change for display
    final percentChange = (sale.profit / sale.amount * 100).toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sale date and ID
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chiffre Affaire',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              
              // Sale amount
              Text(
                '\$${sale.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          
          // Profit percentage
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _getColorForPercentage(double.parse(percentChange)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '$percentChange%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 15),
          
          // Sale details
          Text(
            'Détails de la vente:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${sale.items.length} article(s) vendu(s)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          if (sale.customerId.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'ID Client: ${sale.customerId}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage < 0) {
      return Colors.red;
    } else if (percentage < 30) {
      return Colors.orange;
    } else if (percentage < 50) {
      return Colors.green;
    } else if (percentage < 70) {
      return Colors.blue;
    } else {
      return AppColors.primary;
    }
  }
}
