import 'package:flutter/material.dart';
import 'package:e_pos/viewmodels/company_and_activation_viewmodel.dart';
import 'package:e_pos/views/mycompany_view/calisan_ekle.dart';
import 'package:e_pos/views/mycompany_view/mycompany_screen.dart';
import 'package:e_pos/views/settings_view/settings_screen.dart';
import 'package:e_pos/views/splash_view/splash_screen.dart';
import 'package:e_pos/views/activation_view/activation_screen.dart';
import 'package:e_pos/views/home_view/home_screen.dart';
import 'package:e_pos/views/mywallet_view/mywallet_screen.dart';
import 'package:e_pos/views/login_register_view/base_login_register_views/login_screen.dart';
import 'package:e_pos/views/login_register_view/base_login_register_views/register_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/wallet_viewmodel.dart';
import 'viewmodels/payment_viewmodel.dart';



void main()  {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => CompanyAndActivationViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sanal Pos',
        initialRoute: '/splashScreen',
        routes: {
          '/splashScreen' : (context) => SplashScreen(),
          '/': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/mycompany': (context) => MyCompanyScreen(),
          '/activation': (context) => ActivationScreen(),
          '/calisanekle' : (context) => CalisanEkleScreen(),
          '/mywallet' : (context) => MyWalletScreen(),
          '/settings' : (context) => SettingsScreen(),

        },
      ),
    );
  }
}
