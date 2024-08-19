import 'package:flutter/material.dart';
import 'package:e_pos/services/user_service.dart';
import '../../services/token_service.dart';

class SplashScreen extends StatelessWidget {

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  void _checkLogin(BuildContext context) async {
    final token = await TokenService.getToken();

    if (token != null) {

      final isValid = await _userService.validateToken(token);
      if (isValid) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

}