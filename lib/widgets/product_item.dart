import 'package:flutter/material.dart';
import 'package:retail_app/models/product.dart';
import 'package:retail_app/utils/constants.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  ProductItem({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(12),
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
        child: Row(
          children: [
            // Product image placeholder
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                getIconForCategory(product.category),
                size: 35,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 15),
            
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Stock: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        '${product.stock}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Prix: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onTap,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Show delete confirmation
                    // This would be implemented in the provider
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Suppression non implémentée')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'montre':
      case 'montres':
        return Icons.watch;
      case 'chaussure':
      case 'chaussures':
        return Icons.shopping_bag;
      case 'vêtement':
      case 'vêtements':
        return Icons.checkroom;
      case 'électronique':
        return Icons.devices;
      case 'accessoire':
      case 'accessoires':
        return Icons.headset;
      default:
        return Icons.inventory_2;
    }
  }
}
