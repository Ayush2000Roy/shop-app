import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  // final String title;
  // final double price;

  // ProductDetailsScreen(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String; // id
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Text(loadedProduct.title),
                  ),
                  background: Hero(
                    tag: loadedProduct.id,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                              'Image not available\nSomething went wrong:(')),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loadedProduct.description,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          '₹ ${loadedProduct.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Chip(
                          label: Text(
                            'Ak assured',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('Free delivery'),
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green[600],
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          cart.addItem(loadedProduct.id, loadedProduct.price,
                              loadedProduct.title);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item added to cart!'),
                              duration: Duration(seconds: 3),
                              elevation: 5,
                              backgroundColor: Theme.of(context).primaryColor,
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: Colors.amber[200],
                                onPressed: () {
                                  cart.undoItemCart(loadedProduct.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(10),
                      elevation: 2,
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'BUY NOW',
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        cart.addItem(loadedProduct.id, loadedProduct.price,
                            loadedProduct.title);
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
