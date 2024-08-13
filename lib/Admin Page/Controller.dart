import 'package:daily_grocer/User%20Page/Home%20page.dart';
import 'package:flutter/cupertino.dart';

import 'Model.dart';

class CatogoriesController extends ChangeNotifier{
  List<Pagecontroller> _Itempages = [
  ];
  List<Pagecontroller> get Itempages => _Itempages;
  notifyListeners();

}
class HomePageController extends ChangeNotifier{
  List<HomePageModel> _HomePages=[
    HomePageModel(HomePage: "Add Item"),
    HomePageModel(HomePage: "Remove item"),
    HomePageModel(HomePage: "Add category"),
    HomePageModel(HomePage: "Remove category"),
    HomePageModel(HomePage: "Users"),
    HomePageModel(HomePage: "Order"),
    HomePageModel(HomePage: "Notification"),
  ];
  List<HomePageModel> get HomePages=>_HomePages;
}