import 'dart:convert';
import 'dart:io';

import '../models/product_model.dart';
import 'package:path_provider/path_provider.dart';
import '../paths/image_paths.dart';

class ProductService {
  List<Product> getMockProducts() {
    return [
        Product(
          id: 1,
          name: "Nike Air Max",
          price: 129.99,
          quantity: 10,
          description: "Comfortable running shoes.",
          imagePath: productImagePaths[0],
        ),
        Product(
          id: 2,
          name: "Adidas Ultraboost",
          price: 149.99,
          quantity: 5,
          description: "Premium sports shoes.",
          imagePath: productImagePaths[1],
        ),
        Product(
          id: 3,
          name: "Puma Sneakers",
          price: 89.99,
          quantity: 8,
          description: "Stylish and lightweight.",
          imagePath: productImagePaths[2],
        ),
      ];
    }

  final String _fileName = 'products.json';
  
  Future<void> insertMockProductsIfEmpty() async {
  final file = await _getFile();
  final content = await file.readAsString();

  final jsonData = jsonDecode(content);
    if ((jsonData['product'] as List).isEmpty) {
      final mockProducts = getMockProducts();
      final productList = ProductList(productModel: mockProducts);
      final json = jsonEncode(productList.toJson());
      await file.writeAsString(json);
    }
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<void> getJsonFilePath() async {
    final path = await _getFilePath();
    print('📂 products.json file path: $path');
  }

  Future<void> printJsonContent() async {
    final file = await _getFile();
    final content = await file.readAsString();
    print('🔍 products.json content:\n$content');
  }

  Future<File> _getFile() async {
    final path = await _getFilePath();
    final file = File(path);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({'product': []}));
    }

    return file;
  }

  Future<ProductList> getAllProducts() async {
    final file = await _getFile();
    final content = await file.readAsString();
    final json = jsonDecode(content);
    return ProductList.fromJson(json);
  }

  Future<void> addProduct(Product newProduct) async {
    final file = await _getFile();
    final productList = await getAllProducts();

    final updatedList = List<Product>.from(productList.productModel)..add(newProduct);
    final updatedUserList = ProductList(productModel: updatedList);

    final json = jsonEncode(updatedUserList.toJson());
    await file.writeAsString(json);
  }

  Future<void> clearProducts() async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode({'product': []}));
  }
}