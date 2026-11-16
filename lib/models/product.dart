/// Ürün veri modeli.
///
/// `assets/data/products.json` dosyasındaki her bir ürün bu sınıfa
/// [Product.fromJson] ile dönüştürülür.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;

  /// API'den gelen biçimlenmiş fiyat, örn. "$1,299"
  final String price;
  final String currency;

  /// Yerel görsel yolu (assets/...)
  final String image;

  /// Görselin orijinal (internet) adresi
  final String? imageUrl;

  /// Ürün özellikleri, örn. {"chip": "A17 Pro", "material": "Titanium"}
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    this.imageUrl,
    this.specs = const {},
  });

  /// JSON (Map) -> Product
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'];
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: (json['tagline'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      price: (json['price'] ?? '') as String,
      currency: (json['currency'] ?? 'USD') as String,
      image: json['image'] as String,
      imageUrl: json['imageUrl'] as String?,
      specs: rawSpecs is Map
          ? rawSpecs.map((key, value) => MapEntry(key.toString(), value.toString()))
          : const {},
    );
  }

  /// Product -> JSON (Map)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'price': price,
        'currency': currency,
        'image': image,
        'imageUrl': imageUrl,
        'specs': specs,
      };

  /// "$1,299" -> 1299.0  (sepet toplamı hesaplamak için)
  double get priceValue {
    final digits = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 0;
  }

  /// Ürün kategorisi; isimden türetilir (filtreleme için).
  String get category {
    final n = name.toLowerCase();
    if (n.contains('iphone')) return 'iPhone';
    if (n.contains('macbook') || n.contains('imac')) return 'Mac';
    if (n.contains('ipad')) return 'iPad';
    if (n.contains('watch')) return 'Watch';
    return 'Ses & Diğer';
  }

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
