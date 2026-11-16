import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

/// Named route sabitleri ve route üretici.
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  /// Route Arguments: detay sayfasına [Product] nesnesi argüman olarak taşınır.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen(), settings: settings);
      case detail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product), settings: settings);
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Sayfa bulunamadı'))),
          settings: settings,
        );
    }
  }
}
