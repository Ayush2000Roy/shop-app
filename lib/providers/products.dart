import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red T-shirt',
    //   description: 'A red t-shirt - it is pretty red!',
    //   price: 529.50,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 1559.00,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 250.00,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 149.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Apple Pie',
    //   description:
    //       'A tasty treat to gift your loved ones, ready out of the box',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2020/08/11/13/58/apple-pie-5479993_1280.jpg',
    //   price: 950.99,
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Apple Macbook Air Pro',
    //   description:
    //       'Simply a beast laptop. Exceptionally a professional machine, can handle anything except games.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2017/06/20/23/15/coffee-2425303_1280.jpg',
    //   price: 249990.00,
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Apple iPhone 5',
    //   description: 'The name is enough ;)',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2017/04/03/15/52/mobile-phone-2198770_1280.png',
    //   price: 25950.90,
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Mercedes AMG GT',
    //   description:
    //       'A decent car with good top speed, awesome acceleration and somewhat pretty handling and nitro efficiency.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_1280.jpg',
    //   price: 9099000.00,
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Euro 2016 OMB',
    //   description:
    //       'The official match ball of Euro 2016 competition. Light weight, high efficiency, low magnus effect.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/05/27/14/33/football-1419954_1280.jpg',
    //   price: 5599.99,
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Russia 2018 WC OMB',
    //   description:
    //       'The official match ball of Russia 2018 World Cup. Official product by Adidas.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2018/06/14/16/36/football-3475163_1280.jpg',
    //   price: 7890.99,
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'CR7 Juve Mug',
    //   description:
    //       'A pure gem for a CR7 fan. Hurry limited stocks. Make it yours today.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2020/03/18/15/39/christian-4944506_1280.jpg',
    //   price: 899.99,
    // ),
    // Product(
    //   id: 'p12',
    //   title: 'Mini Cooper 1:6 Model',
    //   description:
    //       'A real model of the Mini Cooper. So real you won\'t believe unless you buy it.',
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2014/11/23/12/11/toy-542701_1280.jpg',
    //   price: 699.99,
    // ),
  ];

  // var _showFavOnly = false;
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavOnly) {
    //   return _items.where((element) => element.isFavorite);
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-app-4a1e3.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-shop-app-4a1e3.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(Product(
          id: prodID,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: favData == null ? false : favData[prodID] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-4a1e3.firebaseio.com/products.json?auth=$authToken';
    // 'await' means that it should wait for the code to finish then execute invisible 'then' block.
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      // The below block of code is invisibly wrapped around a 'then' block.
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // To add at the start of the list
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          'https://flutter-shop-app-4a1e3.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: 'Updating failed',
        backgroundColor: Colors.white,
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-app-4a1e3.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t delete product');
    }
    existingProduct = null;
  }

  // void undoDeleteProduct(String id) {
  //   final product = _items.where((element) => element.id == id);
  //   _items.add(product);
  // }

  // void showFavoritesOnly() {
  //   _showFavOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavOnly = false;
  //   notifyListeners();
  // }
}
