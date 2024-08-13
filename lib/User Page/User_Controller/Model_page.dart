import 'package:cloud_firestore/cloud_firestore.dart';
class GroceryItem {
  final String Allname;
  final String AllimageUrl;

  GroceryItem({
    required this.Allname,
    required this.AllimageUrl,
  });

  factory GroceryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GroceryItem(
      Allname: data['name'] ?? '',
      AllimageUrl: data['imageUrl'] ?? '',
    );
  }
}
class CartItem {
  final String name;
  final double price;
  final String imageUrl;
  final int gram;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.gram,
    this.quantity = 1,
  });
  factory CartItem.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CartItem(
      name: doc['name'],
      price: doc['price'],
      imageUrl: doc['imageUrl'],
      gram: doc['gram'],
      quantity: doc['quantity'],
    );
  }

}


