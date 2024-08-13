import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../AdminHomepage.dart';

class RemoveCategoryPage extends StatefulWidget {
  @override
  _RemoveCategoryPageState createState() => _RemoveCategoryPageState();
}

class _RemoveCategoryPageState extends State<RemoveCategoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteCategory(String categoryId) async {
    await _firestore.collection('Categories').doc(categoryId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category removed successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Remove Category', style: TextStyle(color: Colors.amber[800])),
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
          stream: _firestore.collection('Categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No categories available.', style: TextStyle(fontSize: 18)));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final categoryData = doc.data() as Map<String, dynamic>;
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        categoryData['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(categoryData['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(doc.id),
                    ),
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
