import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_button.dart';

/// Ürün detay sayfası. Ürün, Route Arguments ile gelir.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  static const Map<String, String> _specLabels = {
    'audio': 'Ses',
    'battery': 'Pil',
    'brightness': 'Parlaklık',
    'camera': 'Kamera',
    'cancellation': 'Gürültü Engelleme',
    'carbon': 'Karbon',
    'case': 'Kasa',
    'chip': 'İşlemci',
    'colors': 'Renkler',
    'connectivity': 'Bağlantı',
    'control': 'Kontrol',
    'design': 'Tasarım',
    'display': 'Ekran',
    'driver': 'Sürücü',
    'feature': 'Özellik',
    'gps': 'GPS',
    'home': 'Akıllı Ev',
    'id': 'Kimlik',
    'material': 'Malzeme',
    'materials': 'Malzemeler',
    'os': 'İşletim Sistemi',
    'pencil': 'Kalem',
    'ports': 'Portlar',
    'screen': 'Ekran',
    'sensing': 'Algılama',
    'size': 'Boyut',
    'weight': 'Ağırlık',
  };

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cart = CartScope.of(context);
    final inCart = cart.quantityOf(product);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Geri'),
        titleSpacing: 0,
        actions: const [CartButton(), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: AspectRatio(
              aspectRatio: 1.15,
              child: Container(
                color: AppTheme.surface,
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(product.name, style: text.titleLarge)),
                    const SizedBox(width: 12),
                    Text(product.price,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.accent)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(product.tagline, style: text.bodySmall?.copyWith(fontSize: 14)),
                const SizedBox(height: 20),
                Text('Açıklama', style: text.titleMedium),
                const SizedBox(height: 6),
                Text(product.description, style: text.bodyMedium),
                if (product.specs.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text('Özellikler', style: text.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: product.specs.entries
                        .map((e) => _SpecTile(label: _specLabels[e.key] ?? e.key, value: e.value))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: () {
              cart.add(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('${product.name} sepete eklendi'),
                  duration: const Duration(seconds: 2),
                ));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(inCart == 0 ? 'Sepete Ekle' : 'Sepete Ekle ($inCart sepette)'),
          ),
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final String label;
  final String value;

  const _SpecTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5EA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: const TextStyle(fontSize: 10, color: AppTheme.muted, letterSpacing: 0.6, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink)),
        ],
      ),
    );
  }
}
