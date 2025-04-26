import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/sales_provider.dart';
import 'package:retail_app/widgets/sale_history_item.dart';
import 'package:retail_app/utils/constants.dart';

class SalesHistoryScreen extends StatefulWidget {
  @override
  _SalesHistoryScreenState createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSalesHistory();
  }

  Future<void> _loadSalesHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<SalesProvider>(context, listen: false).refreshSalesData();
    } catch (e) {
      print('Error loading sales history: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement de l\'historique des ventes')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshSalesHistory() async {
    return _loadSalesHistory();
  }

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final sales = salesProvider.sales;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historique',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : sales.isEmpty
              ? Center(
                  child: Text(
                    'Aucune vente trouvée',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshSalesHistory,
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: sales.length,
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      return SaleHistoryItem(sale: sale);
                    },
                  ),
                ),
    );
  }
}
