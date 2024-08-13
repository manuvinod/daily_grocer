import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../User Page/BillPage.dart';
import '../AdminHomepage.dart'; // Import necessary dependencies

class AdminBillingPage extends StatelessWidget {
  const AdminBillingPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchBillingDetails() async {
    final billingDetails = <Map<String, dynamic>>[];

    try {
      final billingSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .get();

      for (var userDoc in billingSnapshot.docs) {
        final username = userDoc.get('UserName'); // Replace with actual field name
        final billingCollection = userDoc.reference.collection('billingDetails');
        final userBillingSnapshot = await billingCollection.orderBy('timestamp', descending: true).get();

        for (var billingDoc in userBillingSnapshot.docs) {
          final billing = billingDoc.data();
          billing['username'] = username; // Add username to billing details
          billingDetails.add(billing);
        }
      }
    } catch (e) {
      print('Error fetching billing details: $e');
    }

    return billingDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Billing Details', style: TextStyle(color: Colors.amber[800])),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage(),));
          },
          icon: Icon(Icons.arrow_back,color: Colors.amber[800],),
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
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp)
                    : 'No timestamp';
                final username = billing['username'] ?? 'Unknown'; // Handle null usernames

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${index + 1}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Placed',
                                style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$username',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.amber[900],fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Date/Time: $formattedDate',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
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
