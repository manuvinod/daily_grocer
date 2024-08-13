import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'User_Controller/Grocery Controller.dart';
class LikedItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liked Items',
          style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
        ),
      ),
      body: Consumer<LikedItemsModel>(
        builder: (context, likedItems, child) {
          if (likedItems.likedItems.isEmpty) {
            return Center(child: Text('No liked items.'));
          }
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: likedItems.likedItems.length,
                  itemBuilder: (context, index) {
                    final item = likedItems.likedItems[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    item['imageUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  item['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item['price']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Grams: ${item['gram']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 1,
                            child: Consumer<LikedItemsModel>(
                              builder: (context, likedItems, child) {
                                bool isLiked = likedItems.isLiked(item);
                                return IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.amber[800],
                                  ),
                                  onPressed: () {
                                    if (isLiked) {
                                      likedItems.removeItem(item);
                                    } else {
                                      likedItems.addItem(item);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(isLiked ? 'Item removed from liked' : 'Item liked')),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    final cart = Provider.of<CartModel>(context, listen: false);
                    final likedItemsModel = Provider.of<LikedItemsModel>(context, listen: false);
                    for (var item in likedItemsModel.likedItems) {
                      cart.newAddToCart(
                        imgUrl: item['imageUrl'],
                        name: item['name'],
                        price: item['price'],
                        quantity: 1,
                        productID: item['itemId'],
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('All items added to cart')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Add All to Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
