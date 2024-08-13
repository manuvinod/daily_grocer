import 'package:daily_grocer/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Admin Page/Controller.dart';
import 'User Page/GetStart.dart';
import 'User Page/SplashScreen.dart';
import 'User Page/User_Controller/Auth_Controller.dart';
import 'User Page/User_Controller/Grocery Controller.dart';



void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Authentication()),
        ChangeNotifierProvider(create: (context)=>GroceryController()),
        ChangeNotifierProvider(create: (context)=>CartModel()),
         ChangeNotifierProvider(create: (context)=>CatogoriesController()),
         ChangeNotifierProvider(create: (context)=>HomePageController()),
         ChangeNotifierProvider(create: (context)=>PurchaseController()),
         ChangeNotifierProvider(create: (context)=>LikedItemsModel()),
         ChangeNotifierProvider(create: (context)=>ProfileController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home:SplashScreen(),
      ),
    );
  }
}

