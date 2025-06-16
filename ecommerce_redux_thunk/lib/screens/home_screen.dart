import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/states/app_state.dart';
import '../redux/states/product_state.dart';
import '../redux/middlewares/product_thunk.dart';
import '../constans/texts.dart';
import '../constans/colors.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

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

          final filteredProducts = product.products.where((p) {
            final query = searchQuery.toLowerCase();
            return p.name.toLowerCase().contains(query) ||
                   p.description.toLowerCase().contains(query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  cursorColor: CustomColors.backgroundColor,
                  style: TextStyle(color: CustomColors.backgroundColor),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: CustomColors.backgroundColor),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: CustomColors.backgroundColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: CustomColors.backgroundColor), // 🔹 border color (inactive)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: CustomColors.backgroundColor, width: 2), // 🔹 border color (active)
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 270,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return SingleChildScrollView(
            // padding: const EdgeInsets.all(16.0),
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
                    store.dispatch(clearProductsThunk());
                  },
                  child: const Text(
                    'Clear Products',
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
