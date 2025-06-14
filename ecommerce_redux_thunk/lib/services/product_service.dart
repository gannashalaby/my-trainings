import 'dart:convert';
import 'dart:io';

import '../models/product_model.dart';
import 'package:path_provider/path_provider.dart';

class ProductService {
  final String _fileName = 'products.json';
  
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
}