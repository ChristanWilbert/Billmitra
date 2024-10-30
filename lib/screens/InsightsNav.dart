import 'package:bill_mitra/screens/analytics/BusinessPerformanceScreen.dart';
import 'package:bill_mitra/screens/analytics/BusinessPredictionScreen.dart';
import 'package:bill_mitra/util/CustomButton.dart';
import 'package:bill_mitra/util/UnderDevelopment.dart';
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
        child: Expanded(
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
        content: const Text('Information about using the Bill Mitra app.'),
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
