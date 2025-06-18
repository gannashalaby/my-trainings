import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/cart_model.dart';

class CartService {
  Future<String> _getFilePath(String username) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/cart_$username.json';
  }

  Future<List<CartItem>> loadCart(String username) async {
    final path = await _getFilePath(username);
    final file = File(path);
    if (!await file.exists()) return [];

    final content = await file.readAsString();
    final data = json.decode(content) as List;
    return data.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<void> saveCart(String username, List<CartItem> items) async {
    final path = await _getFilePath(username);
    final file = File(path);
    final data = json.encode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(data);
  }

  Future<void> clearCart(String username) async {
    final path = await _getFilePath(username);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}