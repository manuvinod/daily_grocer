import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_grocer/User%20Page/payment%20page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'User_Controller/Grocery Controller.dart';

class PurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final purchaseController = Provider.of<PurchaseController>(context, listen: false);

    Future<void> saveBillingDetails() async {
      final cartItemsSnapshot = await cart.getCartItems();
      final cartItems = cartItemsSnapshot.docs.map((doc){
        var data=doc.data();
        data.remove("imageUrl");
        return data;
      }).toList();

      final billingDetails = {
        'cartItems': cartItems,
        'totalPrice': await cart.totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await purchaseController.saveBillingDetails(billingDetails);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Purchase', style: TextStyle(color: Colors.amber[800], fontSize: 25, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.amber[800],),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Billing Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: FutureBuilder(
                    future: cart.getCartItems(),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading cart items"));
                      } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                        return Center(child: Text("No items in the cart"));
                      } else {
                        final cartItems = snapshot.data.docs;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var item in cartItems)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Unit Price: \$${item['price'].toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                        ),
                                        Text(
                                          'Quantity: ${item['quantity']}',
                                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Total: \$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            Divider(),
                            FutureBuilder<double>(
                              future: cart.totalPrice,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text("Error calculating total"));
                                } else {
                                  final totalPrice = snapshot.data ?? 0.0;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await saveBillingDetails();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size(400, 60),
                ),
                child: Text(
                  "Buy Now",
                  style: TextStyle(color: Colors.amber[800], fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
