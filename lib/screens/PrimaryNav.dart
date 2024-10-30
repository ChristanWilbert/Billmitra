import 'package:bill_mitra/screens/InsightsNav.dart';
import 'package:bill_mitra/screens/InventoryNav.dart';
import 'package:bill_mitra/screens/InvoiceNav.dart';
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
      body: Center(
        child: Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text("Bill Mitra",
                  style: GoogleFonts.jacquesFrancois(
                      color: Colors.black, fontSize: 40)),
              SizedBox(
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
                  SizedBox(height: 30),
                  CustomButton(
                    text: 'Invoices',
                    bg: "blue",
                    onPressed: () => navigateTo(context, InvoiceNav()),
                  ),
                  SizedBox(height: 30),
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
        child: Icon(Icons.help_outline),
      ),
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help'),
        content: Text('Information about using the Bill Mitra app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
