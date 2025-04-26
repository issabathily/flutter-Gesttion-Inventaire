import 'package:flutter/material.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/utils/constants.dart';

class CustomerItem extends StatelessWidget {
  final Customer customer;

  CustomerItem({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Customer avatar
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
          SizedBox(width: 15),
          
          // Customer details
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
                SizedBox(height: 5),
                Text(
                  customer.contactInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
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
                  SnackBar(content: Text('Appel non implémenté')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Envoyer un message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message non implémenté')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modification non implémentée')),
                );
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
}
