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

  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Low Price', 'High Price'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Home Page'),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
      ),

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

          if (selectedFilter == 'Low Price') {
            filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          } else if (selectedFilter == 'High Price') {
            filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
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
                            borderSide: BorderSide(color: CustomColors.backgroundColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: CustomColors.backgroundColor, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: CustomColors.backgroundColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedFilter,
                            iconEnabledColor: CustomColors.backgroundColor,
                            style: TextStyle(color: CustomColors.backgroundColor),
                            borderRadius: BorderRadius.circular(12),
                            items: filterOptions.map((filter) {
                              return DropdownMenuItem(
                                value: filter,
                                child: Text(filter),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                // ElevatedButton(
                //   onPressed: () {
                //     store.dispatch(clearProductsThunk());
                //   },
                //   child: const Text(
                //     'Clear Products',
                //     style: CustomTextStyles.smallButtonText,
                //   ),
                // ),
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
