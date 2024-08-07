import 'package:flutter/material.dart';
import 'package:flutterprojects/services/user_service.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '../../services/token_service.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import '/views/widgets/custom_scaffold.dart'; // CustomScaffold'ı import edin


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
      // Token geçerli mi kontrol et
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