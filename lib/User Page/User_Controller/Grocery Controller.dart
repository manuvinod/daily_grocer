      import 'package:firebase_auth/firebase_auth.dart';
      import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
      import 'Model_page.dart';
      import 'package:flutter/widgets.dart';
      import 'package:cloud_firestore/cloud_firestore.dart';

      class GroceryController with ChangeNotifier {
        List<GroceryItem> _items = [];
        List<GroceryItem> get items => _items;
        GroceryController() {
          loadCategoriesFromFirebase();
        }

        void loadCategoriesFromFirebase() {
          FirebaseFirestore.instance.collection('Categories').snapshots().listen((snapshot) {
            _items = snapshot.docs.map((doc) {
              return GroceryItem(
                Allname: doc['name'],
                AllimageUrl: doc['imageUrl'],
              );
            }).toList();
          });
        }

        notifyListeners();
      }

      class CartModel extends ChangeNotifier {


      Future<bool>  helperISItemAdded (productID)async{
          final user = FirebaseAuth.instance.currentUser;
          var cart = await  FirebaseFirestore.instance
              .collection("Users")
              .doc(user!.uid)
              .collection("cart").get();
          if(cart.docs.contains(productID)){
            return true;
          }else{
            return false;
          }
        }

        List<CartItem> _items = [];

        List<CartItem> get items => _items;
      Future<double> get totalPrice async {
        double total = 0.0;
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return total;
        }

        final cartCollection = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('cart');

        final cartItemsSnapshot = await cartCollection.get();

        for (var doc in cartItemsSnapshot.docs) {
          total += doc['price'] * doc['quantity'];
        }

        return total;
      }

        void addToCart(CartItem item) {
          _items.add(item);
          notifyListeners();
          saveCartItemsToFirebase();
        }

        newAddToCart({required imgUrl,required name,required price,required quantity,required productID}) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          var cart = await  FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .collection("cart").get();
          if(cart.docs.contains(productID)){
            var cartItem = await  FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .collection("cart").doc(productID).get();
            var cartQuantity = cartItem["quantity"];
            var data ={"imageUrl":imgUrl,"name":name,"price":price,"quantity":cartQuantity+1};
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .collection("cart").doc(productID).update(data);
          }else {
            var data ={"imageUrl":imgUrl,"name":name,"price":price,"quantity":quantity};

            await FirebaseFirestore.instance
                .collection("Users")
                .doc(user.uid)
                .collection("cart").doc(productID).set( data);
          }
        }

        void removeFromCart(id) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          final cartCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('cart');
          await cartCollection.doc(id).delete();
        }

        Future<void> saveCartItemsToFirebase() async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          final cartCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('cart');

          final cartItemsSnapshot = await cartCollection.get();
          for (final doc in cartItemsSnapshot.docs) {
            await doc.reference.delete();
          }
          for (final item in _items) {
            await cartCollection.add({
              'name': item.name,
              'price': item.price,
              'imageUrl': item.imageUrl,
              'quantity': item.quantity,
            });
          }
        }
        /// Get Cart Item  Of User

        getCartItems() async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          final cartCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('cart');

          final cartItemsSnapshot = await cartCollection.get();

          return cartItemsSnapshot;
        }

        /// ------ It Ends here

        Future<void> loadCartItemsFromFirebase() async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          final cartCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('cart');

          final cartItemsSnapshot = await cartCollection.get();

          _items = cartItemsSnapshot.docs.map((doc) {
            return CartItem(
              name: doc['name'],
              price: doc['price'],
              imageUrl: doc['imageUrl'],
              quantity: doc['quantity'],
              gram: doc[""],
            );
          }).toList();
        }
      Future<void> clearCart() async {
        final cartItems = await getCartItems();
        for (var item in cartItems.docs) {
          await item.reference.delete();
        }
        notifyListeners();
      }
        notifyListeners();
      }
      class PurchaseController with ChangeNotifier {
        Future<void> saveBillingDetails(Map<String, dynamic> billingDetails) async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return;
          }

          final billingCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('billingDetails');

          await billingCollection.add(billingDetails);
        }

        Future<QuerySnapshot?> getBillingDetails() async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return null;
          }

          final billingCollection = FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .collection('billingDetails');

          return await billingCollection.get();
        }
        notifyListeners();
      }
      class LikedItemsModel with ChangeNotifier {
        List<Map<String, dynamic>> _likedItems = [];

        List<Map<String, dynamic>> get likedItems => _likedItems;

        void addItem(Map<String, dynamic> item) {
          if (!_likedItems.contains(item)) {
            _likedItems.add(item);
            notifyListeners();
          }
        }

        void removeItem(Map<String, dynamic> item) {
          if (_likedItems.contains(item)) {
            _likedItems.remove(item);
            notifyListeners();
          }
        }

        bool isLiked(Map<String, dynamic> item) {
          return _likedItems.contains(item);
        }
        notifyListeners();
      }
      class ProfileController with ChangeNotifier {
        String _profileImage = '';

        String get profileImage => _profileImage;

        ProfileController() {
          loadProfileImage();
        }

        Future<void> loadProfileImage() async {
          final prefs = await SharedPreferences.getInstance();
          _profileImage = prefs.getString('profileImage') ?? '';
          notifyListeners();
        }

        Future<void> saveProfileImage(String imagePath) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('profileImage', imagePath);
          _profileImage = imagePath;
          notifyListeners();
        }
      }

