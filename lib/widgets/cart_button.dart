import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/cart.dart';

/// Sağ üstteki sepet ikonu; sepetteki ürün sayısını rozet olarak gösterir.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).count;
    return IconButton(
      tooltip: 'Sepet',
      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.shopping_bag_outlined, size: 26),
      ),
    );
  }
}
