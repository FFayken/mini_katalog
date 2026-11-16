import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Ürün verilerini sağlayan sınıf.
///
/// Gerçek bir API yerine, https://wantapi.com/products.php adresinden
/// alınıp `assets/data/products.json` dosyasına kaydedilmiş veriyi okur
/// (JSON simülasyonu). Ekstra paket gerektirmez.
class ProductRepository {
  static const String _path = 'assets/data/products.json';

  List<Product>? _cache;

  Future<List<Product>> fetchProducts() async {
    if (_cache != null) return _cache!;

    // Ağdan geliyormuş gibi kısa bir gecikme (yükleme göstergesini görmek için)
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final raw = await rootBundle.loadString(_path);
    final Map<String, dynamic> decoded = json.decode(raw) as Map<String, dynamic>;
    final list = decoded['products'] as List<dynamic>;

    _cache = list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }
}
