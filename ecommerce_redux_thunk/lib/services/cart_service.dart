import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class CartService {
  Future<String> _getFilePath(String? username) async {
    final dir = await getApplicationDocumentsDirectory();
    return username != null ? '${dir.path}/cart_$username.json' : '${dir.path}/guest_cart.json';
  }

  Future<List<CartItem>> loadCart(String? username) async {
    final path = await _getFilePath(username);
    final file = File(path);
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final data = json.decode(content) as List;
    List<CartItem> loadedCart =  data.map((item) => CartItem.fromJson(item)).toList();

    final productService = ProductService();
    final productList = await productService.getAllProducts();
    final currentProducts = productList.productModel;

    List<CartItem> updatedCart = loadedCart.map((cartItem) {
      final matchingProduct = currentProducts.firstWhere(
        (p) => p.id == cartItem.productInCart.id,
        orElse: () => Product(
          id: cartItem.productInCart.id,
          name: cartItem.productInCart.name,
          price: cartItem.productInCart.price,
          quantity: 0, // sold out
          description: cartItem.productInCart.description,
          imagePath: cartItem.productInCart.imagePath,
        ),
      );

      return CartItem(
        productInCart: matchingProduct,
        quantityInCart: cartItem.quantityInCart,
      );
    }).toList();

    return updatedCart;
  } //every time loads cart, it compares the items in the cart with the products in the product list.
    // if the product is not in the product list, it displays soldout it from the cart.
    // if the product details are updated in the product list, it updates the cart item with the new details.

  Future<void> saveCart(String? username, List<CartItem> items) async {
    final path = await _getFilePath(username);
    final file = File(path);
    final data = json.encode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(data);
  }

  Future<void> clearCart(String? username) async {
    final path = await _getFilePath(username);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}