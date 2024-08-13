import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'BottomBar_page.dart';
import 'User_Controller/Grocery Controller.dart';

class Successful extends StatelessWidget {
  const Successful({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/images/Animation - 1720778572210.json",
              width: 200,
              height: 200,
              fit: BoxFit.cover
            ),
            SizedBox(height: 20,),
            Text("Successfull",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Text("Your payment was done successfully",style: TextStyle(color: Colors.grey,fontSize: 18),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: ()async{
                await cart.clearCart();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(),));
              },style: ElevatedButton.styleFrom(primary: Colors.red,minimumSize: Size(300, 50),shape: RoundedRectangleBorder()),
                  child: Text("OK",style: TextStyle(color: Colors.white),)
              ),
            )
          ],
        ),
      ),
    );
  }
}
