import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retail_app/models/product.dart';
import 'package:retail_app/providers/product_provider.dart';
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
            // Product image or icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: product.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        getIconForCategory(product.category),
                        size: 35,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : Icon(
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
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Voulez-vous vraiment supprimer ce produit?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop();
                              try {
                                await Provider.of<ProductProvider>(context, listen: false)
                                    .deleteProduct(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Produit supprimé avec succès')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur lors de la suppression')),
                                );
                              }
                            },
                            child: Text('Supprimer'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
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
