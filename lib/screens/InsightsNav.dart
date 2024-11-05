import 'package:bill_mitra/screens/analytics/BusinessPerformanceScreen.dart';
import 'package:bill_mitra/screens/analytics/BusinessPredictionScreen.dart';
import 'package:bill_mitra/util/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightsNav extends StatelessWidget {
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
            Text("Insights",
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
                  text: 'Business Performance',
                  bg: "blue",
                  onPressed: () =>
                      navigateTo(context, BusinessPerformanceScreen()),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: 'Business Prediction',
                  bg: "blue",
                  onPressed: () =>
                      navigateTo(context, BusinessPredictionScreen()),
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
            "Observe your business activities visually and plan accordingly\n->Navigate to 'Business Performance' page to see a graphical presentation of the overall businesses\n->Navigate to 'Business Predictions' page to get a graphical representation of future business trends based on the past data"),
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
