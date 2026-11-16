import 'package:flutter/widgets.dart';

import '../models/product.dart';

/// Sepetteki bir satır: ürün + adet
class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});

  double get total => product.priceValue * quantity;
}

/// Basit sepet durumu (simülasyon).
///
/// [ChangeNotifier] Flutter'ın kendi sınıfıdır; ekstra state yönetimi
/// paketi kullanılmaz. Sepet değiştiğinde [notifyListeners] çağrılır ve
/// [CartScope] altındaki widget'lar yeniden çizilir.
class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get count => _items.fold(0, (sum, i) => sum + i.quantity);

  double get total => _items.fold(0, (sum, i) => sum + i.total);

  bool get isEmpty => _items.isEmpty;

  int quantityOf(Product p) {
    for (final i in _items) {
      if (i.product == p) return i.quantity;
    }
    return 0;
  }

  void add(Product p) {
    final index = _items.indexWhere((i) => i.product == p);
    if (index == -1) {
      _items.add(CartItem(p));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  /// Bir adet azaltır; adet 0 olursa satırı kaldırır.
  void decrease(Product p) {
    final index = _items.indexWhere((i) => i.product == p);
    if (index == -1) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(Product p) {
    _items.removeWhere((i) => i.product == p);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Sepeti widget ağacına dağıtan InheritedNotifier.
/// Kullanım: `CartScope.of(context).add(product)`
class CartScope extends InheritedNotifier<Cart> {
  const CartScope({super.key, required Cart cart, required super.child}) : super(notifier: cart);

  static Cart of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadı');
    return scope!.notifier!;
  }
}
