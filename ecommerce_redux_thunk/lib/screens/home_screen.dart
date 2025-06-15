import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ecommerce_redux_thunk/redux/states/app_state.dart';
import 'package:ecommerce_redux_thunk/redux/states/product_state.dart';
import 'package:ecommerce_redux_thunk/redux/middlewares/product_thunk.dart';
import 'package:ecommerce_redux_thunk/constans/texts.dart';
import 'package:ecommerce_redux_thunk/widgets/product_card.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget  {
  static const String id = '/home';
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),

      body: StoreConnector<AppState, ProductState>(
        onInit: (store) => store.dispatch(fetchProductsThunk()),
        // converter: (store) => store.state.productState.productList,
        converter: (store) => ProductState(
          isLoading: store.state.productState.isLoading, 
          products: store.state.productState.products,
          errorMessage: store.state.productState.errorMessage,
        ),
        builder: (context, product) {
          if (product.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (product.errorMessage != null) {
            return Center(child: Text('Error: ${product.errorMessage}'));
          }

          if (product.products.isEmpty) {
            return const Center(child: Text("No products found"));
          }
          return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: product.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: product.products[index]);
              },
            );
          },
        ),

        bottomNavigationBar: StoreConnector<AppState, Store<AppState>>(
            converter: (store) => store,
            builder: (context, store) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        store.dispatch(printProductsThunk());
                      },
                      child: const Text(
                        'Print Products',
                        style: CustomTextStyles.smallButtonText,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        store.dispatch(printProductPathThunk());
                      },
                      child: const Text(
                        'Print Products Path',
                        style: CustomTextStyles.smallButtonText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}