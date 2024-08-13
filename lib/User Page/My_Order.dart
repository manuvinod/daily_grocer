import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'BillPage.dart';
import 'BottomBar_page.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchBillingDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final billingDetails = <Map<String, dynamic>>[];

    if (currentUser != null) {
      final billingSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('billingDetails')
          .orderBy('timestamp', descending: true)
          .get();

      for (var billingDoc in billingSnapshot.docs) {
        billingDetails.add(billingDoc.data());
      }
    }

    return billingDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'My Order',
            style: TextStyle(color: Colors.amber[800],fontSize: 24,fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBillingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No billing details found'));
          } else {
            final billingDetails = snapshot.data!;
            return ListView.builder(
              itemCount: billingDetails.length,
              itemBuilder: (context, index) {
                final billing = billingDetails[index];
                final timestamp = (billing['timestamp'] as Timestamp?)?.toDate();
                final formattedDate = timestamp != null
                    ? DateFormat('yyyy-MM-dd').format(timestamp)
                    : 'No timestamp';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${index + 1}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Order Date: $formattedDate',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullOrderDetailsPage(billing: billing),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
