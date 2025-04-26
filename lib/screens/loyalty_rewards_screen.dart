import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/providers/customer_provider.dart';
import 'package:retail_app/utils/constants.dart';

class LoyaltyRewardsScreen extends StatefulWidget {
  @override
  _LoyaltyRewardsScreenState createState() => _LoyaltyRewardsScreenState();
}

class _LoyaltyRewardsScreenState extends State<LoyaltyRewardsScreen> {
  final List<Map<String, dynamic>> _rewardsOptions = [
    {
      'points': 100,
      'title': 'Réduction de 10%',
      'description': 'Obtenez une réduction de 10% sur votre prochain achat',
      'color': Colors.blue,
      'icon': Icons.discount,
    },
    {
      'points': 200,
      'title': 'Réduction de 20%',
      'description': 'Obtenez une réduction de 20% sur votre prochain achat',
      'color': Colors.green,
      'icon': Icons.discount,
    },
    {
      'points': 300,
      'title': 'Produit gratuit',
      'description': 'Recevez un produit gratuit de votre choix (max \$50)',
      'color': Colors.purple,
      'icon': Icons.card_giftcard,
    },
    {
      'points': 500,
      'title': 'Livraison gratuite',
      'description': 'Bénéficiez de la livraison gratuite pendant 3 mois',
      'color': Colors.orange,
      'icon': Icons.local_shipping,
    },
    {
      'points': 1000,
      'title': 'Statut VIP',
      'description': 'Obtenez le statut VIP avec des avantages exclusifs',
      'color': Colors.red,
      'icon': Icons.star,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final loyalCustomers = customerProvider.loyalCustomers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Programme de Fidélité',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Programme de Fidélité',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Récompensez vos clients fidèles',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Rewards Options
              Text(
                'Options de Récompenses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 16),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _rewardsOptions.length,
                itemBuilder: (context, index) {
                  final reward = _rewardsOptions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildRewardCard(reward),
                  );
                },
              ),
              SizedBox(height: 24),

              // Eligible Customers
              Text(
                'Clients Éligibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 16),
              loyalCustomers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Aucun client éligible pour le moment',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: loyalCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = loyalCustomers[index];
                        return _buildEligibleCustomerCard(customer);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard(Map<String, dynamic> reward) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: reward['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                reward['icon'],
                color: reward['color'],
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    reward['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: reward['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${reward['points']} pts',
                style: TextStyle(
                  color: reward['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibleCustomerCard(Customer customer) {
    return InkWell(
      onTap: () => _showRedeemDialog(customer),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Niveau: ${customer.tier}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${customer.loyaltyPoints} pts',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showRedeemDialog(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Utiliser les points'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${customer.name} a ${customer.loyaltyPoints} points',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Choisissez une récompense à échanger:'),
            SizedBox(height: 8),
            ..._rewardsOptions
                .where((reward) => reward['points'] <= customer.loyaltyPoints)
                .map((reward) => ListTile(
                      leading: Icon(reward['icon'], color: reward['color']),
                      title: Text(reward['title']),
                      subtitle: Text('${reward['points']} points'),
                      onTap: () => _redeemPoints(customer, reward),
                    ))
                .toList(),
            if (_rewardsOptions
                .where((reward) => reward['points'] <= customer.loyaltyPoints)
                .isEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ce client n\'a pas assez de points pour les récompenses disponibles.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
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

  void _redeemPoints(Customer customer, Map<String, dynamic> reward) async {
    try {
      final points = reward['points'] as int;
      final updatedCustomer = customer.copyWith(
        loyaltyPoints: customer.loyaltyPoints - points,
      );

      await Provider.of<CustomerProvider>(context, listen: false)
          .updateCustomer(updatedCustomer);

      Navigator.pop(context); // Close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${customer.name} a échangé ${points} points contre "${reward['title']}"'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'échange des points: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}