import 'package:flutter/material.dart';



class HomeScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue, // AppBar rengi
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Drawer başlık rengi
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Profil resmi
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Company',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('My Wallet'),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // Ayarlar sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.home_work),
              title: Text('My Company'),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // Ayarlar sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.verified),
              title: Text('Activation'),
              onTap: () {
                Navigator.pushNamed(context, '/about'); // Hakkında sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/about'); // Hakkında sayfasına git
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Çıkış işlemleri
                Navigator.pop(context); // Drawer'ı kapat
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to Home Screen!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),

        ),
      ),
    );
  }
}
