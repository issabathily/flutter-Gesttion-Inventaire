import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/product_provider.dart';
import 'package:retail_app/screens/add_product_screen.dart';
import 'package:retail_app/screens/product_detail_screen.dart';
import 'package:retail_app/widgets/bottom_nav_bar.dart';
import 'package:retail_app/widgets/product_item.dart';
import 'package:retail_app/utils/constants.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductProvider>(context, listen: false).refreshProducts();
    } catch (e) {
      print('Error loading products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des produits')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProducts() async {
    return _loadProducts();
  }

  void _onSearch(String query) {
    Provider.of<ProductProvider>(context, listen: false).setSearchQuery(query);
  }

  void _navigateToProductDetail(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: productId),
      ),
    ).then((_) => _refreshProducts());
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(),
      ),
    ).then((_) => _refreshProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produits(produits)',
          style: TextStyle(color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                onChanged: _onSearch,
              ),
            ),
          ),

          // Products list
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : products.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun produit trouvé',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshProducts,
                        child: ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: products.length,
                          separatorBuilder: (context, index) => SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItem(
                              product: product,
                              onTap: () => _navigateToProductDetail(product.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
