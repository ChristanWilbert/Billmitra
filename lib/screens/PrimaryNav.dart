import 'package:bill_mitra/screens/InsightsNav.dart';
import 'package:bill_mitra/screens/InventoryNav.dart';
import 'package:bill_mitra/screens/InvoiceScreens/InvoiceNav.dart';
import 'package:bill_mitra/util/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryNav extends StatelessWidget {
  void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text("Bill Mitra",
                  style: GoogleFonts.jacquesFrancois(
                      color: Colors.black, fontSize: 40)),
              const SizedBox(
                height: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Insights',
                    bg: "blue",
                    onPressed: () => navigateTo(context, InsightsNav()),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Invoices',
                    bg: "blue",
                    onPressed: () => navigateTo(context, InvoiceNav()),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Inventory',
                    bg: "blue",
                    onPressed: () => navigateTo(context, InventoryNav()),
                  ),
                ],
              ),
            ],
          ),
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
            'Navigate to the desired services by selecting the provided options \n->Go to Insights to get an overview of the overall business\n->Go to Invoices to access all the recorded transactions\n->Go to Inventory to observe the stock management'),
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
