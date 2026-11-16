import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart.dart';

void main() {
  const json = {
    'id': 1,
    'name': 'iPhone 15 Pro',
    'tagline': 'Titanium.',
    'description': 'Açıklama',
    'price': r'$1,299',
    'currency': 'USD',
    'image': 'assets/images/products/iphone.png',
    'specs': {'chip': 'A17 Pro'},
  };

  group('Product', () {
    test('fromJson alanları doğru okur', () {
      final p = Product.fromJson(json);
      expect(p.id, 1);
      expect(p.name, 'iPhone 15 Pro');
      expect(p.specs['chip'], 'A17 Pro');
      expect(p.category, 'iPhone');
    });

    test('fiyat metni sayıya çevrilir', () {
      expect(Product.fromJson(json).priceValue, 1299);
    });

    test('toJson -> fromJson aynı ürünü verir', () {
      final p = Product.fromJson(json);
      final again = Product.fromJson(p.toJson());
      expect(again, p);
      expect(again.price, p.price);
    });
  });

  group('Cart', () {
    test('ekleme, azaltma ve toplam', () {
      final cart = Cart();
      final p = Product.fromJson(json);
      var notified = 0;
      cart.addListener(() => notified++);

      cart.add(p);
      cart.add(p);
      expect(cart.count, 2);
      expect(cart.total, 2598);

      cart.decrease(p);
      expect(cart.quantityOf(p), 1);

      cart.decrease(p);
      expect(cart.isEmpty, isTrue);
      expect(notified, 4);
    });
  });
}
