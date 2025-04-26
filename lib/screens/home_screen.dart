import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/auth_provider.dart';
import 'package:retail_app/providers/product_provider.dart';
import 'package:retail_app/providers/sales_provider.dart';
import 'package:retail_app/widgets/bottom_nav_bar.dart';
import 'package:retail_app/widgets/metric_card.dart';
import 'package:retail_app/widgets/sales_chart.dart';
import 'package:retail_app/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data from providers
      await Provider.of<ProductProvider>(context, listen: false).refreshProducts();
      await Provider.of<SalesProvider>(context, listen: false).refreshSalesData();
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des données')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    return _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Get data from providers
    final authProvider = Provider.of<AuthProvider>(context);
    final salesProvider = Provider.of<SalesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Dashboard',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Recherche...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          productProvider.setSearchQuery(query);
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    // Sales chart
                    Text(
                      'Statistique des ventes par Mois',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 10),
                    SalesChart(salesData: salesProvider.monthlySalesData),
                    SizedBox(height: 30),

                    // Metrics section
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            title: 'Vente Du Jour',
                            value: '\$ ${salesProvider.dailyRevenue.toStringAsFixed(2)}',
                            color: AppColors.primary,
                            textColor: Colors.white,
                            percentChange: 8.5,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: MetricCard(
                            title: 'Bénéfices',
                            value: '\$ ${salesProvider.totalProfit.toStringAsFixed(2)}',
                            color: Colors.white,
                            textColor: AppColors.textDark,
                            percentChange: 3.0,
                            isPositiveChange: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Stock count
                    Text(
                      'Stocks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(20),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 30,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 15),
                          Text(
                            '${salesProvider.totalStock}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
