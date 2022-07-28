import 'package:flutter/material.dart';
import 'package:test_sql/screen/add_employee_screen.dart';
import 'package:test_sql/screen/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/second':
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('No Route'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text(
              'Sorry, no route was found!.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
