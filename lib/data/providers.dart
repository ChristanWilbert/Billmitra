import 'package:flutter/foundation.dart';

class LoginState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class CurrentWidgetState extends ChangeNotifier {
  String _currentWidget = 'Home';

  String get currentWidget => _currentWidget;

  void setCurrentWidget(String widgetName) {
    _currentWidget = widgetName;
    notifyListeners();
  }
}

class UserDetailsState extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }
}
