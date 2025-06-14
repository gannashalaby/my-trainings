class ProductList {
  List<Product> productModel;

  ProductList({required this.productModel});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    var productModelFromJson = json['product'] as List;
    List<Product> products = productModelFromJson
        .map((productJson) => Product.fromJson(productJson))
        .toList();
    return ProductList(productModel: products);
  }

  Map<String, dynamic> toJson() {
    return {'product': productModel.map((product) => product.toJson()).toList()};
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String imagePath;

  Product({required this.id, required this.name, required this.price, required this.quantity, required this.description, required this.imagePath});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['id'], name: json['name'], price: (json['price'] as num).toDouble(), quantity: json['quantity'], description: json['description'], imagePath: json['imagePath']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'quantity': quantity, 'description': description, 'imagePath': imagePath};
  }
}
