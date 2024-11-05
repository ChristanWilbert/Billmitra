import 'package:bill_mitra/screens/InvoiceScreens/purchaseinvoicelists.dart';
import 'package:bill_mitra/screens/InvoiceScreens/salesinvoicelistscreen.dart';
import 'package:bill_mitra/util/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceNav extends StatelessWidget {
  void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text("Invoice\nManagement",
                textAlign: TextAlign.center,
                style: GoogleFonts.jacquesFrancois(
                    color: Colors.black, fontSize: 35)),
            const SizedBox(
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Sales',
                  bg: "green",
                  onPressed: () => navigateTo(context, SalesInvoiceScreen()),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: 'Purchase',
                  bg: "red",
                  onPressed: () => navigateTo(context, PurchaseInvoiceScreen()),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the help button
          showHelpDialog(context);
        },
        child: const Icon(Icons.help_outline),
      ),
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help'),
        content: const Text(
            "Get the sales and purchase transaction details respectively"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
