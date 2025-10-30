import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../../services/product_service.dart';
import '../actions/product_action.dart';
import '../states/app_state.dart';

final productService = ProductService();

ThunkAction<AppState> fetchProductsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(FetchProductRequest());

    try {
      // await Future.delayed(const Duration(seconds: 2));

      // final existingProducts = await productService.getAllProducts();
      final mockProducts = productService.getMockProducts();

      // if (existingProducts.productModel != mockProducts) {
        for (var product in mockProducts) {
          await productService.addProduct(product);
        }

        store.dispatch(FetchProductSuccess(mockProducts));
      // } else {
      //   store.dispatch(FetchProductSuccess(existingProducts.productModel));
      // }
    } catch (error) {
      store.dispatch(FetchProductFailure(error.toString()));
    }
  };
}

ThunkAction<AppState> syncProductsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(FetchProductRequest());

    try {
      final products = await productService.getAllProducts();
      store.dispatch(FetchProductSuccess(products.productModel));
    } catch (error) {
      store.dispatch(FetchProductFailure(error.toString()));
    }
  };
}

ThunkAction<AppState> clearProductsThunk() {
  return (Store<AppState> store) async {
    store.dispatch(FetchProductRequest());

    try {
      await productService.clearProducts();
      store.dispatch(FetchProductSuccess([]));
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
