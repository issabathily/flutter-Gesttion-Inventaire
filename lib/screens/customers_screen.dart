import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/models/customer.dart';
import 'package:retail_app/providers/customer_provider.dart';
import 'package:retail_app/screens/add_customer_screen.dart';
import 'package:retail_app/screens/loyalty_rewards_screen.dart';
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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
  
  void _filterCustomers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }
  
  List<Customer> _getFilteredCustomers(List<Customer> customers) {
    if (_searchQuery.isEmpty) {
      return customers;
    }
    
    return customers.where((customer) => 
      customer.name.toLowerCase().contains(_searchQuery) ||
      customer.contactInfo.toLowerCase().contains(_searchQuery) ||
      customer.customerType.toLowerCase().contains(_searchQuery)
    ).toList();
  }
  
  void _navigateToAddCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustomerScreen(),
      ),
    ).then((_) => _refreshCustomers());
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers = _getFilteredCustomers(customerProvider.customers);
    
    // Customer stats
    final platinumCount = customerProvider.getCustomersByTier('Platinum').length;
    final goldCount = customerProvider.getCustomersByTier('Gold').length;
    final silverCount = customerProvider.getCustomersByTier('Silver').length;
    final bronzeCount = customerProvider.getCustomersByTier('Bronze').length;
    final loyalCount = customerProvider.loyalCustomers.length;
    final totalCount = customerProvider.customers.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clients Fidèles',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.card_giftcard, color: AppColors.textDark),
            tooltip: 'Programme de fidélité',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoyaltyRewardsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.textDark),
            tooltip: 'Filtrer',
            onPressed: () {
              _showFilterDialog(context, customerProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Recherche...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: _filterCustomers,
              ),
            ),
          ),
          
          // Customer stats
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, '$totalCount', 'Total', Colors.grey),
                  _buildStat(context, '$loyalCount', 'Fidèles', AppColors.primary),
                  _buildStat(context, '$platinumCount', 'Platinum', Color(0xFF8E44AD)),
                  _buildStat(context, '$goldCount', 'Gold', Color(0xFFFFD700)),
                  _buildStat(context, '$silverCount', 'Silver', Color(0xFF95A5A6)),
                  _buildStat(context, '$bronzeCount', 'Bronze', Color(0xFFCD7F32)),
                ],
              ),
            ),
          ),
          
          // Filter indicator
          if (customerProvider.filterType != 'all')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text(
                    'Filtré par: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Chip(
                    label: Text(
                      _getFilterName(customerProvider.filterType),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getFilterColor(customerProvider.filterType),
                    deleteIcon: Icon(Icons.clear, size: 18, color: Colors.white),
                    onDeleted: () {
                      customerProvider.setFilterType('all');
                    },
                  ),
                ],
              ),
            ),
          
          // Customer list
          Expanded(
            child: _isLoading
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
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CustomerItem(customer: customer),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCustomer,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.person_add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
  
  Widget _buildStat(BuildContext context, String value, String label, Color color) {
    return InkWell(
      onTap: () {
        final filterType = label.toLowerCase();
        Provider.of<CustomerProvider>(context, listen: false).setFilterType(
          filterType == 'total' ? 'all' : filterType == 'fidèles' ? 'loyal' : filterType.toLowerCase()
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
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
    );
  }
  
  void _showFilterDialog(BuildContext context, CustomerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filtrer les clients'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(context, provider, 'all', 'Tous les clients', Colors.grey),
            _buildFilterOption(context, provider, 'loyal', 'Clients fidèles', AppColors.primary),
            _buildFilterOption(context, provider, 'platinum', 'Niveau Platinum', Color(0xFF8E44AD)),
            _buildFilterOption(context, provider, 'gold', 'Niveau Gold', Color(0xFFFFD700)),
            _buildFilterOption(context, provider, 'silver', 'Niveau Silver', Color(0xFF95A5A6)),
            _buildFilterOption(context, provider, 'bronze', 'Niveau Bronze', Color(0xFFCD7F32)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterOption(
    BuildContext context, 
    CustomerProvider provider, 
    String filterType, 
    String label, 
    Color color
  ) {
    return ListTile(
      leading: Icon(
        provider.filterType == filterType 
            ? Icons.radio_button_checked 
            : Icons.radio_button_unchecked,
        color: color,
      ),
      title: Text(label),
      onTap: () {
        provider.setFilterType(filterType);
        Navigator.pop(context);
      },
    );
  }
  
  String _getFilterName(String filterType) {
    switch (filterType) {
      case 'loyal': return 'Clients fidèles';
      case 'platinum': return 'Niveau Platinum';
      case 'gold': return 'Niveau Gold';
      case 'silver': return 'Niveau Silver';
      case 'bronze': return 'Niveau Bronze';
      default: return 'Tous';
    }
  }
  
  Color _getFilterColor(String filterType) {
    switch (filterType) {
      case 'loyal': return AppColors.primary;
      case 'platinum': return Color(0xFF8E44AD);
      case 'gold': return Color(0xFFFFD700);
      case 'silver': return Color(0xFF95A5A6);
      case 'bronze': return Color(0xFFCD7F32);
      default: return Colors.grey;
    }
  }
}
