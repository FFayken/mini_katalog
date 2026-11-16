import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';

/// Sepet sayfası (simülasyon): ürünler, adet arttırma/azaltma, toplam ve ödeme.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _money(double v) {
    // 1299.0 -> "$1,299"
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '\$$buf';
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Sepet'), titleSpacing: 0),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              itemCount: cart.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFEFEFF2)),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                final p = item.product;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: p),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(p.image, width: 56, height: 56, fit: BoxFit.cover),
                  ),
                  title: Text(p.name, style: text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(p.price,
                      style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700, fontSize: 13)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Azalt',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.decrease(p),
                        icon: const Icon(Icons.remove_circle_outline, color: AppTheme.muted),
                      ),
                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      IconButton(
                        tooltip: 'Arttır',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.add(p),
                        icon: const Icon(Icons.add_circle_outline, color: AppTheme.ink),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: AppTheme.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cart.isEmpty ? 'Bu bir eğitim uygulamasıdır; ödeme alınmaz.' : '${cart.count} ürün',
                        style: text.bodySmall,
                      ),
                    ),
                    if (!cart.isEmpty)
                      Text('Toplam  ${_money(cart.total)}', style: text.titleMedium),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: cart.isEmpty
                    ? null
                    : () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Siparişi onayla'),
                            content: Text('Toplam ${_money(cart.total)} tutarındaki sipariş oluşturulsun mu?\n\n'
                                '(Simülasyon — gerçek ödeme yapılmaz.)'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Onayla')),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          cart.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Siparişiniz alındı! (simülasyon)')),
                          );
                        }
                      },
                child: const Text('Ödemeye Geç'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.remove_shopping_cart_outlined, size: 56, color: AppTheme.muted),
          const SizedBox(height: 12),
          Text('Sepetin boş', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Alışverişe başlamak için ürün ekle.', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home)),
            child: const Text('Ürünlere göz at'),
          ),
        ],
      ),
    );
  }
}
