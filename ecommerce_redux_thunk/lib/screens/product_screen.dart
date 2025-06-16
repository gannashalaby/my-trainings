import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/product_model.dart';
import '../constans/colors.dart';
import '../constans/texts.dart';
import '../screens/cart_screen.dart';
import '../widgets/product_card.dart';
import '../redux/states/app_state.dart';
import '../redux/states/recommended_product_state.dart';
import '../redux/middlewares/recommended_product_thunk.dart';

class ProductScreen extends StatefulWidget {
  static const String id = '/productDetails';

  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),

      body: StoreConnector<AppState, RecommendedProductState>(
        onInit: (store) => store.dispatch(fetchRecommendedProductsThunk(widget.product)),
        converter: (store) => RecommendedProductState(
          isLoading: store.state.recommendedProductState.isLoading,
          recommendedProducts: store.state.recommendedProductState.recommendedProducts,
          errorMessage: store.state.recommendedProductState.errorMessage,
        ),
        builder: (context, recommendedProducts) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: CustomColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: CustomColors.textColor, blurRadius: 4),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      widget.product.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.backgroundColor,
                    shadows: [
                      Shadow(
                        offset: Offset(1.5, 1.5),
                        blurRadius: 1.0,
                        color: CustomColors.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CustomColors.backgroundColor.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            r'SAR' '${widget.product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: CustomColors.backgroundColor,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 1.0,
                                  color: CustomColors.textColor,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Text('+', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    CartScreen.id,
                                    arguments: widget.product,
                                  );
                                },
                                child: const Text(
                                  'Add to Cart',
                                  style: CustomTextStyles.smallButtonText,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('-', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CustomColors.backgroundColor.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.product.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CustomColors.backgroundColor,
                        shadows: [
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 1.0,
                            color: CustomColors.textColor,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CustomColors.backgroundColor.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recommended Products',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColors.backgroundColor),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: recommendedProducts.recommendedProducts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 270,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            return ProductCard(product: recommendedProducts.recommendedProducts[index]);
                          },
                        ),
                        // SizedBox(
                        //   height: 220,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: getRecommendedProducts().length,
                        //     itemBuilder: (context, index) {
                        //       final product = getRecommendedProducts()[index];
                        //       return Padding(
                        //         padding: const EdgeInsets.only(right: 12),
                        //         child: ProductCard(product: product),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
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