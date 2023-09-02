import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/product.dart';

class ProductProvider extends ChangeNotifier {
  List<product> _products = [];
  List<product> get products => _products;
  double _total = 0;

  double get total => _total;
  void AddProduct(product pro) {
    int Index = 0;
    bool itContains = false;
    for (int i = 0; i < products.length; i++) {
      if (products[i].name == pro.name && products[i].size == pro.size) {
        Index = i;
        itContains = true;
      }
    }
    if (!itContains) {
      products.add(pro);
    } else {
      products[Index].qty =
          (int.parse(products[Index].qty) + int.parse(pro.qty)).toString();
    }
    _total += double.parse(pro.price) * int.parse(pro.qty);

    notifyListeners();
  }

  void RemoveProduct(String id, double amt) {
    products.removeWhere((element) => element.id == id);

    _total -= amt;
    notifyListeners();
  }

  void ResetTotal() {
    _total = 0.0;
    notifyListeners();
  }
}
