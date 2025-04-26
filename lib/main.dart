import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/auth_provider.dart';
import 'package:retail_app/providers/product_provider.dart';
import 'package:retail_app/providers/customer_provider.dart';
import 'package:retail_app/providers/sales_provider.dart';
import 'package:retail_app/screens/welcome_screen.dart';
import 'package:retail_app/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
      ],
      child: MaterialApp(
        title: 'Weirel Stock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: WelcomeScreen(),
      ),
    );
  }
}
