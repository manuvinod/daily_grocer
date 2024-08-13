import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../User Page/LoginPage.dart';
import '../User Page/User_Controller/Auth_Controller.dart';
import '../User Page/User_Controller/Grocery Controller.dart';
import 'Hom_pages/Add_categories.dart';
import 'Controller.dart';
import 'Hom_pages/Add_Item.dart';
import 'Hom_pages/Admin_Notf.dart';
import 'Hom_pages/Order.dart';
import 'Hom_pages/Remove_Categories.dart';
import 'Hom_pages/Remove_Item.dart';
import 'Hom_pages/Users.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  void logout(BuildContext context) async {
    final auth = Provider.of<Authentication>(context, listen: false);
    await auth.clearLoginState();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('ADMIN', style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.power_settings_new_outlined, color: Colors.amber[800]),
          )
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data!.docs;

                return Container(
                  height: 120,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index].data() as Map<String, dynamic>;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(category['imageUrl']),
                          ),
                          SizedBox(height: 8),
                          Text(category['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 15);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<HomePageController>(
                builder: (context, value, child) {
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: value.HomePages.length,
                    itemBuilder: (context, index) {
                      final pages = value.HomePages[index];
                      return InkWell(
                        onTap: () {
                          if (pages.HomePage == "Add Item") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemPage()));
                          } else if (pages.HomePage == "Remove item") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RemoveItemPage()));
                          } else if (pages.HomePage == "Add category") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryPage()));
                          } else if (pages.HomePage == "Remove category") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RemoveCategoryPage()));
                          } else if (pages.HomePage == "Users") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminUserDetailsPage()));
                          } else if (pages.HomePage == "Order") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminBillingPage()));
                          } else if (pages.HomePage == "Notification") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNotification()));
                          }
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.black54],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.amber.shade800,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              pages.HomePage,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(5.0, 5.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
