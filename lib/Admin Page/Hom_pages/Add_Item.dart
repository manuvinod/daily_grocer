import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  File? _imageFile;
  UploadTask? _uploadTask;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  String? _selectedCategory;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || _selectedCategory == null) return;
    try {
      final Reference ref = FirebaseStorage.instance.ref().child("item_images").child(DateTime.now().millisecondsSinceEpoch.toString());
      setState(() {
        _uploadTask = ref.putFile(_imageFile!);
      });
      await _uploadTask!.whenComplete(() async {
        final url = await ref.getDownloadURL();
        print("Image uploaded: $url");

        await FirebaseFirestore.instance.collection('Items').add({
          'name': _nameController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'gram': _gramController.text,
          'imageUrl': url,
          'category': _selectedCategory,  // Add category field
        });

        // Clear fields and reset state
        _nameController.clear();
        _priceController.clear();
        _gramController.clear();
        setState(() {
          _imageFile = null;
          _uploadTask = null;
          _selectedCategory = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added successfully')),
        );
      });
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      setState(() {
        _uploadTask = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Add Item',style: TextStyle(color: Colors.amber[800]),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.amber[800],),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final categories = snapshot.data!.docs.map((doc) => doc['name'].toString()).toList();

                return DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _gramController,
              decoration: InputDecoration(
                labelText: 'Grams',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              icon: Icon(Icons.add_a_photo),
              style: ElevatedButton.styleFrom(primary: Colors.amber[800],minimumSize: Size(400, 60)),
              onPressed: () => _pickImage(ImageSource.gallery),
              label: Text('Pick Image',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
            ),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            if (_uploadTask != null)
              StreamBuilder<TaskSnapshot>(
                stream: _uploadTask!.snapshotEvents,
                builder: (context, snapshot) {
                  var progress = 0.0;
                  if (snapshot.hasData) {
                    progress = (snapshot.data!.bytesTransferred / snapshot.data!.totalBytes) * 100;
                  }
                  return Column(
                    children: [
                      LinearProgressIndicator(value: progress),
                      Text('${progress.toStringAsFixed(2)} %'),
                    ],
                  );
                },
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black,minimumSize: Size(400, 60)),
              onPressed: _uploadImage,
              child: Text('Upload Image and Add Item',style: TextStyle(color: Colors.amber[800],fontWeight: FontWeight.bold,fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
