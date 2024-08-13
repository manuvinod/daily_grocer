import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'BottomBar_page.dart';
import 'User_Controller/Grocery Controller.dart';
class CategoryItemsPage extends StatelessWidget {
  final String categoryName;

  CategoryItemsPage({required this.categoryName});
  final List<String> images = [
    "assets/images/fruits add1.jpeg",
    "assets/images/fruits add2.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomBar()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
        ),
      ),
      body: Column(
        children: [
          CarouselSlider(
            items: images.map((item) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Items')
                  .where('category', isEqualTo: categoryName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!.docs.map((doc) {
                  return {
                    'name': doc['name'],
                    'imageUrl': doc['imageUrl'],
                    'price': doc['price'],
                    'gram': doc['gram'],
                    'itemId': doc.id
                  };
                }).toList();

                if (items.isEmpty) {
                  return Center(child: Text('No items found in this category.'));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
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
                              Consumer<CartModel>(
                                builder: (context, cart, child) => ElevatedButton(
                                  onPressed: () {
                                    // Add item to cart
                                    cart.newAddToCart(
                                      imgUrl: item['imageUrl'],
                                      name: item['name'],
                                      price: item['price'],
                                      quantity: 1,
                                      productID: item['itemId'],
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Item added to cart')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[800],
                                    ),
                                  ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
