import 'package:flutter/material.dart';
import 'package:tinynote/screen/login.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const LoginPage(),
    '/login': (context) => const LoginPage(),
    // '/home': (context) => DashboardPage()
  };
}
