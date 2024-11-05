import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class AuthService {
  late FirebaseApp app1;

  AuthService() {
    initFirebase();
  }

  Future<void> initFirebase() async {
    app1 = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<bool> authenticateUser(String username, String password) async {
    try {
      // Hash the password using SHA-256
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      // Fetch the user document from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> usernames =
          snapshot.docs.map((doc) => doc['username'] as String).toList();

      // Check if user exists
      if (!usernames.contains(username)) {
        print("User not found");
        return false;
      }

      // Get stored password hash
      // Get stored password hash
      String storedHash = snapshot.docs.firstWhere(
            (doc) => doc['username'] as String == username,
          )['passwordhash'] ??
          '';
      // Compare the stored hash with the provided hash
      return hashedPassword == storedHash;
    } catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }
}
