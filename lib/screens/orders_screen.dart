import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('Something went wrong :('));
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemBuilder: (context, index) {
                    return OrderItem(orderData.orders[index]);
                  },
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
