    import 'package:flutter/material.dart';

    import 'Purchase_page.dart';
    import 'Successful.dart';

    class PaymentPage extends StatefulWidget {
      const PaymentPage({super.key});

      @override
      _PaymentPageState createState() => _PaymentPageState();
    }

    class _PaymentPageState extends State<PaymentPage> {
      String selected = "";
      String selectedPaymentMethod = "";
      final TextEditingController _addressController = TextEditingController();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Payment',
              style: TextStyle(color: Colors.amber[800],fontSize: 25,fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchasePage(),
                  ),
                );
              },
              icon: Icon(Icons.arrow_back,color: Colors.amber[800],),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delivery Type",style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                  Card(
                    color: Colors.green,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    child: RadioListTile<String>(
                      value: "Home Delivery",
                      groupValue: selected,
                      title: Text("Home Delivery",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      activeColor: Colors.orange.shade900,
                      onChanged: (String? value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                  ),
                  if(selected=="Home Delivery")
                    TextFormField(
                      maxLines: 5,
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: "Enter your Address",
                        border: OutlineInputBorder()
                      ),
                    ),
                  Card(
                   color: Colors.blue.shade800,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    child: RadioListTile<String>(
                      value: "Store Pick-up",
                      groupValue: selected,
                      title: Text("Store Pick-up",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      activeColor: Colors.orange.shade900,
                      onChanged: (String? value) {
                        setState(() {
                          selected = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Payment Method",style: TextStyle(color: Colors.grey.shade600,fontSize: 18),),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedPaymentMethod == "Google pay" ? Colors.orange.shade900 : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Google pay",
                              groupValue: selectedPaymentMethod,
                              title: Text(
                                "Google pay",
                                style: TextStyle(fontSize: 17,),
                              ),
                              activeColor: Colors.orange.shade900,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/G pay.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedPaymentMethod == "PhonePe" ? Colors.orange.shade900 : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "PhonePe",
                              groupValue: selectedPaymentMethod,
                              title: Text(
                                "PhonePe",
                                style: TextStyle(fontSize: 18),
                              ),
                              activeColor: Colors.orange.shade900,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/phone pay2.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: selectedPaymentMethod == "Credit card" ? Colors.orange.shade900 : Colors.grey,
                       ),
                       borderRadius: BorderRadius.circular(8)
                     ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Credit card",
                              groupValue: selectedPaymentMethod,
                              title: Text(
                                "Credit card",
                                style: TextStyle(fontSize: 18),
                              ),
                              activeColor: Colors.orange.shade900,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/Visa master card.png', // Path to your image asset
                              width: 50, // Width of the image
                              height: 50, // Height of the image
                            ),
                          ),
                      ],
                      ),
                    ),
                  ),Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedPaymentMethod == "Amazon pay" ? Colors.orange.shade900 : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Amazon pay",
                              groupValue: selectedPaymentMethod,
                              title: Text(
                                "Amazon pay",
                                style: TextStyle(fontSize: 18),
                              ),
                              activeColor: Colors.orange.shade900,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/Amazone pay.webp', // Path to your image asset
                              width: 50, // Width of the image
                              height: 50, // Height of the image
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: selectedPaymentMethod == "Cash on delivery" ? Colors.orange.shade900 : Colors.grey,
                       ),borderRadius: BorderRadius.circular(8)
                     ),
                      child: RadioListTile<String>(
                        value: "Cash on delivery",
                        groupValue: selectedPaymentMethod,
                        title: Text(
                          "Cash on delivery",
                          style: TextStyle(fontSize: 18),
                        ),
                        activeColor: Colors.orange.shade900,
                        onChanged: (String? value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        String message = 'Selected Delivery Type: $selected';
                        if (selected.isNotEmpty && selectedPaymentMethod.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selecte a payment Method')),
                          );
                        }else if(selected=="Home Delivery"&&_addressController.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter your address')),
                          );
                          return;
                        }else if(selected.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Select a delivery Type"))
                          );
                        }else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Successful(),));
                        }
                      },style: ElevatedButton.styleFrom(primary: Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),minimumSize: Size(400, 60)),
                      child: Text('Proceed to Payment',style: TextStyle(color: Colors.amber[800],fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
