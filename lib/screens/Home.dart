import 'package:bill_mitra/screens/Dashboard.dart';
import 'package:bill_mitra/screens/LoginScreen.dart';
import 'package:bill_mitra/data/providers.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var loginState = Provider.of<LoginState>(context);
    return (loginState.isLoggedIn == true)
        ? const Dashboard()
        : const LoginScreen();
  }
}
