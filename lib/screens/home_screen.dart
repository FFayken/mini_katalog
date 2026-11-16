import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: başlık, arama, banner, kategori filtresi ve ürün grid'i.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _repository = ProductRepository();
  late final Future<List<Product>> _future = _repository.fetchProducts();

  String _query = '';
  String _category = 'Tümü';

  static const List<String> _categories = ['Tümü', 'iPhone', 'Mac', 'iPad', 'Watch', 'Ses & Diğer'];

  /// Basit arama + kategori filtresi
  List<Product> _filter(List<Product> all) {
    final q = _query.trim().toLowerCase();
    return all.where((p) {
      final matchesCategory = _category == 'Tümü' || p.category == _category;
      final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q) || p.tagline.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Ürünler yüklenemedi:\n${snapshot.error}', textAlign: TextAlign.center));
            }

            final products = _filter(snapshot.data!);

            return CustomScrollView(
              slivers: [
                // Başlık
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Keşfet', style: text.headlineMedium),
                              const SizedBox(height: 2),
                              Text('Sana en uygun cihazı bul.', style: text.bodySmall?.copyWith(fontSize: 14)),
                            ],
                          ),
                        ),
                        const CartButton(),
                      ],
                    ),
                  ),
                ),

                // Arama kutusu
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Ürün ara',
                        prefixIcon: Icon(Icons.search, color: AppTheme.muted),
                      ),
                    ),
                  ),
                ),

                // Banner
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 2118 / 474,
                        child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),

                // Kategori filtreleri
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 56,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final c = _categories[i];
                        final selected = c == _category;
                        return ChoiceChip(
                          label: Text(c),
                          selected: selected,
                          showCheckmark: false,
                          onSelected: (_) => setState(() => _category = c),
                          selectedColor: AppTheme.ink,
                          backgroundColor: AppTheme.surface,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppTheme.ink,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      },
                    ),
                  ),
                ),

                // Ürün grid'i
                if (products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('Aramanızla eşleşen ürün yok.')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    sliver: SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, i) => ProductCard(
                        product: products[i],
                        // Route Arguments: ürün nesnesi detay sayfasına gönderilir
                        onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: products[i]),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
