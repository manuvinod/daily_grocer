import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../AdminHomepage.dart';

class RemoveItemPage extends StatefulWidget {
  const RemoveItemPage({super.key});

  @override
  _RemoveItemPageState createState() => _RemoveItemPageState();
}

class _RemoveItemPageState extends State<RemoveItemPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteItem(String itemId) async {
    await _firestore.collection('Items').doc(itemId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Remove Item', style: TextStyle(color: Colors.amber[800])),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
          },
          icon: Icon(Icons.arrow_back, color: Colors.amber[800]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No items available.', style: TextStyle(fontSize: 18)));
            }

            // Group items by category
            final itemsByCategory = <String, List<DocumentSnapshot>>{};
            for (var doc in snapshot.data!.docs) {
              final category = doc['category'] as String;
              if (itemsByCategory.containsKey(category)) {
                itemsByCategory[category]!.add(doc);
              } else {
                itemsByCategory[category] = [doc];
              }
            }

            return ListView(
              children: itemsByCategory.entries.map((entry) {
                final category = entry.key;
                final items = entry.value;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    title: Text(category, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    children: items.map((doc) {
                      final itemData = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            itemData['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(itemData['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Price: ${itemData['price']}\nGrams: ${itemData['gram']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(doc.id),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
