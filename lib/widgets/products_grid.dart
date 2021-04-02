import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavOnly;

  ProductsGrid(this.showFavOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavOnly ? productsData.favItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        // This .value is useful for ListItems, GridItems, etc. where flutter recycles the
        // widget but also it data needs to be changed and so the Notifier doesn't depend
        // on the context.
        return ChangeNotifierProvider.value(
          // create: (context) => products[index],
          value: products[index],
          child: ProductItem(
              // products[index].id,
              // products[index].title,
              // products[index].imageUrl,
              ),
        );
      },
    );
  }
}
