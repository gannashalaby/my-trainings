import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:ecommerce_redux_thunk/services/product_service.dart';
import 'package:ecommerce_redux_thunk/redux/actions/product_action.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';

final productService = ProductService();

ThunkAction<AppState> fetchProductsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(FetchProductRequest());

    try {
      await Future.delayed(const Duration(seconds: 2));

      final existingProducts = await productService.getAllProducts();

      if (existingProducts.productModel.isEmpty) {
        final mockProducts = productService.getMockProducts();

        for (var product in mockProducts) {
          await productService.addProduct(product);
        }

        store.dispatch(FetchProductSuccess(mockProducts));
      } else {
        store.dispatch(FetchProductSuccess(existingProducts.productModel));
      }
    } catch (error) {
      store.dispatch(FetchProductFailure(error.toString()));
    }
  };
}

ThunkAction<AppState> printProductsThunk() {
  return (Store<AppState> store) async {
    await productService.printJsonContent();
  };
}

ThunkAction<AppState> printProductPathThunk() {
  return (Store<AppState> store) async {
    await productService.getJsonFilePath();
  };
}


List<Middleware<AppState>> createProductMiddleware() => [];