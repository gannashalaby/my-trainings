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
          name: "Astatin 20 mg (Atorvastatin)",
          price: 43.45, // SAR
          quantity: 30,
          description: "Statin to lower LDL cholesterol & triglycerides; dose: 10–20 mg once daily. Side effects: muscle pain, headache, liver monitoring needed.",
          imagePath: productImagePaths[0],
        ),
        Product(
          id: 2,
          name: "Azera 100 mg (Aspirin)",
          price: 6.35,
          quantity: 90,
          description: "Low-dose enteric-coated aspirin to prevent blood clots, heart attacks & strokes; dose: 75–100 mg daily. Side effects: GI upset, bleeding risk.",
          imagePath: productImagePaths[1],
        ),
        Product(
          id: 3,
          name: "Bonecare Calcium Complex",
          price: 60.00,
          quantity: 30,
          description: "Supplement with calcium citrate, vit D, zinc & Mg to support bone density and healing.",
          imagePath: productImagePaths[2],
        ),
        Product(
          id: 4,
          name: "Jamieson Calcium 500 mg + Vit D – 90 Caps",
          price: 49.50,
          quantity: 90,
          description: "Calcium + vit D supplement to support bone health; common side effects: GI upset.",
          imagePath: productImagePaths[3],
        ),
        Product(
          id: 5,
          name: "Cardura XL 4 mg (Doxazosin)",
          price: 34.00,
          quantity: 28,
          description: "Alpha‑blocker for hypertension/BPH; dose: 4 mg once daily. Side effects: dizziness, postural hypotension.",
          imagePath: productImagePaths[4],
        ),
        Product(
          id: 6,
          name: "Carvidolol (Carvedilol) 6.25 mg",
          price: 12.90,
          quantity: 30,
          description: "Beta‑blocker for hypertension/heart failure; initial dose 3.125–6.25 mg BID. Side effects: fatigue, dizziness.",
          imagePath: productImagePaths[5],
        ),
        Product(
          id: 7,
          name: "Centrum Complete 30‑tab Multivitamin",
          price: 25.70,
          quantity: 30,
          description: "Daily multivitamin with 24–30 nutrients; supports overall health.",
          imagePath: productImagePaths[6],
        ),
        Product(
          id: 8,
          name: "Ketostril (Alpha‑keto analogues) – 20 Tabs",
          price: 48.00,
          quantity: 20,
          description: "Supplement for chronic kidney disease to delay progression; take with meals. Side effects: GI discomfort.",
          imagePath: productImagePaths[7],
        ),
        Product(
          id: 9,
          name: "Neurobion (Vitamin B‑complex)",
          price: 30.00,
          quantity: 30,
          description: "B1/B6/B12 combo for neuropathy and nerve health; dose: once daily. Side effects: uncommon, mild GI upset.",
          imagePath: productImagePaths[8],
        ),
        Product(
          id: 10,
          name: "Panadol (Paracetamol) 500 mg",
          price: 5.00,
          quantity: 20,
          description: "Pain reliever & fever reducer; dose: 500 mg every 4–6 h (max 4 g/day). Side effects: rare—liver risk with overuse.",
          imagePath: productImagePaths[9],
        ),
        Product(
          id: 11,
          name: "Paracetamol 500 mg – generic",
          price: 4.00,
          quantity: 20,
          description: "Same as Panadol but generic OTC variant.",
          imagePath: productImagePaths[10],
        ),
        Product(
          id: 12,
          name: "Plavix 75 mg (Clopidogrel)",
          price: 70.00,
          quantity: 30,
          description: "Antiplatelet to prevent clots after MI/stroke; dose: 75 mg daily. Side effects: bleeding risk.",
          imagePath: productImagePaths[11],
        ),
      ];
    }

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

    final json = jsonDecode(content);
    final productList = ProductList.fromJson(json);
    print('📏 Number of products in products.json: ${productList.productModel.length}');
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

  Future<List<Product>> getRecommendedProducts(Product currentProduct) async {
    final productList = await getAllProducts();
    return productList.productModel
        .where((p) => p.id != currentProduct.id)
                      // && (p.price - currentProduct.price).abs() <= 10)
        // .take(4)
        .toList();
  }

  Future<void> addProduct(Product newProduct) async {
    final file = await _getFile();
    final productList = await getAllProducts();

    final exists = productList.productModel.any((product) => product.id == newProduct.id);
    if (!exists) {
      final updatedList = List<Product>.from(productList.productModel)..add(newProduct);
      final updatedProductList = ProductList(productModel: updatedList);

      final json = jsonEncode(updatedProductList.toJson());
      await file.writeAsString(json);
    }
  }

  Future<void> clearProducts() async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode({'product': []}));
  }
}