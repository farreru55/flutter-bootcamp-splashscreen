import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/config.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(name: 'Product 1', quantity: 2, price: 10000, shipping_cost: 5000),
    CartItem(name: 'Product 2', quantity: 1, price: 55000, shipping_cost: 0),
    // ... Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Product Image
                  Image.asset('assets/images/produk-digital.jpeg', width: 80, height: 80, fit: BoxFit.cover),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('${item.quantity} x ${Config().formatCurrency(item.price)}', style: const TextStyle(fontSize: 14)),
                        Text('Shipping Cost: ${Config().formatCurrency(item.shipping_cost)}', style: TextStyle(fontSize: 14, color: Colors.grey[700]),),
                        // ... Add more details as needed
                      ],
                    ),
                  ),
                  Text(
                    '${Config().formatCurrency(calculateSubtotal(item))}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Remove item from cart
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${Config().formatCurrency(calculateTotal())}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Proceed to checkout
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotal() {
    return _cartItems.fold(0, (total, item) => total + (item.quantity * item.price + item.shipping_cost));
  }

  int calculateSubtotal(item) {
    return item.quantity * item.price + item.shipping_cost;
  }
}

class CartItem {
  final String name;
  final int quantity;
  final int price;
  final int shipping_cost;

  CartItem({required this.name, required this.quantity, required this.price, required this.shipping_cost});
}
