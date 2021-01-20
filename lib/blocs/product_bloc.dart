import 'dart:async';

import '../contracts/disposable.dart';
import '../models/product.dart';

class ProductsBloc implements Disposable {
  List<Product> products;
  final StreamController<List<Product>> _productsListStreamController =
      StreamController<List<Product>>();
  Stream<List<Product>> get productStream =>
      _productsListStreamController.stream;
  StreamSink<List<Product>> get productsStreamSink =>
      _productsListStreamController.sink;

  final StreamController<Product> _addProductStreamController =
      StreamController<Product>();
  StreamSink<Product> get addProduct => _addProductStreamController.sink;

  final StreamController<Product> _removeProductStreamController =
      StreamController<Product>();
  StreamSink<Product> get removeProduct => _removeProductStreamController.sink;

  ProductsBloc() {
    products = [
      Product('mohamed', 'eid', 15),
      Product('amina', 'AMINA', 20),
    ];
    _productsListStreamController.add(products);
    _addProductStreamController.stream.listen(_addProduct);
    _removeProductStreamController.stream.listen(_removeproduct);
  }

  @override
  void dispose() {
    _productsListStreamController.close();
    _addProductStreamController.close();
    _removeProductStreamController.close();
  }

  void _addProduct(Product product) {
    products.add(product);
    productsStreamSink.add(products);
  }

  void _removeproduct(Product product) {
    products.remove(product);
    productsStreamSink.add(products);
  }
}
