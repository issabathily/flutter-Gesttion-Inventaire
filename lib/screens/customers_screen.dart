import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/customer_provider.dart';
import 'package:retail_app/widgets/bottom_nav_bar.dart';
import 'package:retail_app/widgets/customer_item.dart';
import 'package:retail_app/utils/constants.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final int _selectedIndex = 2;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<CustomerProvider>(context, listen: false).refreshCustomers();
    } catch (e) {
      print('Error loading customers: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des clients')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCustomers() async {
    return _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers = customerProvider.customers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fidel clients',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : customers.isEmpty
              ? Center(
                  child: Text(
                    'Aucun client trouvé',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshCustomers,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: customers.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return CustomerItem(customer: customer);
                    },
                  ),
                ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
