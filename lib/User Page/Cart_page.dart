  import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
  import 'package:provider/provider.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'BottomBar_page.dart';
  import 'Home page.dart';
  import 'User_Controller/Grocery Controller.dart';
  import 'User_Controller/Model_page.dart';
  import 'Purchase_page.dart';

  class CartPage extends StatefulWidget {
    @override
    State<CartPage> createState() => _CartPageState();
  }

  class _CartPageState extends State<CartPage> {
    @override
    Widget build(BuildContext context) {
      final cart = Provider.of<CartModel>(context);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Cart', style: TextStyle(color: Colors.amber[800],fontWeight: FontWeight.bold,fontSize: 25))),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<CartModel>(builder: (BuildContext context, CartModel value, Widget? child) {
                return FutureBuilder(future:Provider.of<CartModel>(context,listen: false).getCartItems(), builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return  Center(child: CircularProgressIndicator(color: Colors.blue[900],));
                }if(snapshot.hasData){
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Lottie.asset('assets/images/Animation - 1721896073654.json', width: 250, height: 250),
                    );
                  }
                  return ListView.builder(itemCount: snapshot.data.docs.length,itemBuilder: (context, index) {
                    final item = snapshot.data.docs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.amber[100],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(item["imageUrl"]),
                              ),
                            ),
                          ),
                          title: Text(item["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Price: \$${item["price"].toStringAsFixed(2)} \nQuantity: ${item["quantity"]}', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                              SizedBox(height: 4),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.red, shape: BeveledRectangleBorder()),
                            child: Text("Remove", style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Provider.of<CartModel>(context,listen: false).removeFromCart(item.id);
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    );

                  },);
                }else
                  {
                    return Text("404");
                  }
                }, );
              },)
            ),
            Divider(height: 0),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<double>(
                    future: cart.totalPrice,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Total: \$0.00',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold));
                      } else if (snapshot.hasError) {
                        return Text('Error calculating total',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold));
                      } else {
                        return Text('Total: \$${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold));
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: ()  {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber[800],
                        elevation: 4,
                        shape: BeveledRectangleBorder(),
                      ),
                      child: Text("Purchase", style: TextStyle(color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
  }
