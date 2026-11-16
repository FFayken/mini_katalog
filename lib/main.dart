import 'package:flutter/material.dart';

import 'routes.dart';
import 'state/cart.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MiniKatalogApp(cart: Cart()));
}

class MiniKatalogApp extends StatelessWidget {
  final Cart cart;

  const MiniKatalogApp({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    // Sepet, tüm sayfaların erişebilmesi için MaterialApp'in üstünde tutulur.
    return CartScope(
      cart: cart,
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
