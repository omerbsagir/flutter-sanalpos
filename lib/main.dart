import 'package:flutter/material.dart';
import 'package:flutterprojects/views/login_register_view/base_login_register_views/register_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_viewmodel.dart';
import 'views/login_register_view/base_login_register_views/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        // Diğer ViewModel'leri burada ekleyin
      ],
      child: MaterialApp(
        title: 'Sanal Pos',
        initialRoute: '/',
        routes: {
          '/': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen()
        },
      ),
    );
  }
}
