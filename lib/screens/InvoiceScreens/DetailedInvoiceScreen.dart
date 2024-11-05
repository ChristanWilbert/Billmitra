import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailedInvoiceScreen extends StatelessWidget {
  final String documentId;
  final bool isSales;

  DetailedInvoiceScreen({required this.documentId, required this.isSales});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isSales
                      ? const Color.fromARGB(255, 6, 114, 10)
                      : const Color.fromARGB(255, 206, 12, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (isSales) ? "SALES" : "PURCHASE",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Text('Invoice',
                  style: TextStyle(
                      color: Color.fromARGB(250, 54, 94, 234), fontSize: 24)),
            ],
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection(isSales ? 'salesinvoice' : 'purchaseinvoices')
            .doc(documentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var address = data['address'] ?? 'No Address';
          var date = (data['date'] as Timestamp).toDate();
          var formattedDate = DateFormat('dd/MM/yyyy').format(date);

          // Filter item keys
          var items = data.entries
              .where((entry) => entry.key.startsWith('item'))
              .map((entry) => entry.value)
              .toList();
          var quants = data.entries
              .where((entry) => entry.key.startsWith('quant'))
              .map((entry) => entry.value)
              .toList();
          var prices = data.entries
              .where((entry) => entry.key.startsWith('price'))
              .map((entry) => entry.value)
              .toList();
          var total = data['total'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(address),
                Text(formattedDate),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      // var itemName = item['name'] ?? 'No Name';
                      var quantity = quants[index] ?? 0;
                      var price = prices[index] ?? 0;
                      var itemTotal = quantity * price;

                      return Card(
                        color:
                            isSales ? Colors.green[100] : Colors.red.shade100,
                        child: ListTile(
                          title: Text(item),
                          subtitle: Text(
                            'Qn:$quantity kg Price:$price',
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            '₹$itemTotal',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('₹$total',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Share functionality
                  },
                  child: const Text('Share'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
