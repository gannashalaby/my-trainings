import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/models/product_model.dart';
import 'package:ecommerce_redux_thunk/services/product_service.dart';
import 'package:ecommerce_redux_thunk/redux/actions/product_action.dart';
import 'package:ecommerce_redux_thunk/paths/image_paths.dart';
import 'package:ecommerce_redux_thunk/redux/states/product_state.dart';

final productService = ProductService();

ThunkAction<ProductState> fetchProductThunk() {
  return (Store<ProductState> store) async {
    store.dispatch(FetchProductRequest());

    try {
      await Future.delayed(Duration(seconds: 2));

      List<Product> productList = [
        Product(
          id: 1,
          name: "Nike Air Max",
          price: 129.99,
          quantity: 10,
          description: "Comfortable running shoes.",
          imagePath: imagePaths[0],
        ),
        Product(
          id: 2,
          name: "Adidas Ultraboost",
          price: 149.99,
          quantity: 5,
          description: "Premium sports shoes.",
          imagePath: imagePaths[1],
        ),
        Product(
          id: 3,
          name: "Puma Sneakers",
          price: 89.99,
          quantity: 8,
          description: "Stylish and lightweight.",
          imagePath: imagePaths[2],
        ),
      ];

      for (int i = 0; i < productList.length; i++) {
        await productService.addProduct(productList[i]);
      }

      store.dispatch(FetchProductSuccess(productList));
    } catch (error) {
      store.dispatch(FetchProductFailure(error.toString()));
    }
  };
}

ThunkAction<ProductState> printProductsThunk() {
  return (Store<ProductState> store) async {
    await productService.printJsonContent();
  };
}

ThunkAction<ProductState> printProductPathThunk() {
  return (Store<ProductState> store) async {
    await productService.getJsonFilePath();
  };
}