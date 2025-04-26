import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/providers/customer_provider.dart';
import 'package:retail_app/utils/constants.dart';

class CustomerItem extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  CustomerItem({required this.customer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color tierColor = _getTierColor(customer.tier);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Customer avatar with tier indicator
            Stack(
              children: [
                // Customer image or initials avatar
                customer.imageUrl != null && customer.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: customer.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            _getInitials(customer.name),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            _getInitials(customer.name),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        _getInitials(customer.name),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  
                // Loyalty badge
                if (customer.isLoyal)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: tierColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 15),
            
            // Customer details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        customer.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tierColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          customer.tier,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: tierColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    customer.contactInfo,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStat(
                        context: context,
                        icon: Icons.shopping_cart,
                        value: customer.purchaseCount.toString(),
                        label: 'Achats',
                      ),
                      SizedBox(width: 10),
                      _buildStat(
                        context: context,
                        icon: Icons.payment,
                        value: '\$${customer.totalSpent.toStringAsFixed(2)}',
                        label: 'Dépensé',
                      ),
                      SizedBox(width: 10),
                      _buildStat(
                        context: context,
                        icon: Icons.emoji_events,
                        value: customer.loyaltyPoints.toString(),
                        label: 'Points',
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
                  icon: Icon(Icons.add_circle, color: AppColors.primary),
                  tooltip: 'Ajouter des points',
                  onPressed: () => _showAddPointsDialog(context),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => _showOptionsDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textLight,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'Platinum':
        return Color(0xFF8E44AD); // Purple
      case 'Gold':
        return Color(0xFFFFD700); // Gold
      case 'Silver':
        return Color(0xFF95A5A6); // Silver
      default:
        return Color(0xFFCD7F32); // Bronze
    }
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '?';
  }

  void _showAddPointsDialog(BuildContext context) {
    final TextEditingController pointsController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter des points de fidélité'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Points actuels: ${customer.loyaltyPoints}'),
            SizedBox(height: 10),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de points à ajouter',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final pointsToAdd = int.tryParse(pointsController.text);
              if (pointsToAdd != null && pointsToAdd > 0) {
                try {
                  await Provider.of<CustomerProvider>(context, listen: false)
                      .addLoyaltyPoints(customer.id, pointsToAdd);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Points ajoutés avec succès')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de l\'ajout des points')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez entrer un nombre valide')),
                );
              }
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Appeler'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appel: ${customer.contactInfo}')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Envoyer un message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message: ${customer.contactInfo}')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart_checkout),
              title: Text('Enregistrer un achat'),
              onTap: () {
                Navigator.pop(context);
                _showRecordPurchaseDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to edit customer screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modifier: ${customer.name}')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Supprimer', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }
  
  void _showRecordPurchaseDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enregistrer un achat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Montant de l\'achat',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                try {
                  await Provider.of<CustomerProvider>(context, listen: false)
                      .recordPurchase(customer.id, amount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Achat enregistré avec succès')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de l\'enregistrement de l\'achat')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez entrer un montant valide')),
                );
              }
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer ce client?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<CustomerProvider>(context, listen: false)
                    .deleteCustomer(customer.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Client supprimé avec succès')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la suppression du client')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
