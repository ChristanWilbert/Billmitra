import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String bg;

  const CustomButton(
      {required this.text, required this.onPressed, required this.bg});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: (bg == "red")
              ? Colors.red
              : (bg == "green")
                  ? Colors.green
                  : Colors.blue, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          minimumSize: Size(250, 60)),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.jacquesFrancois(fontSize: 25, color: Colors.white),
      ),
    );
  }
}
