// lib/widgets/custom_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutterprojects/repositories/user_repository.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;


  CustomScaffold({required this.body,required this.title});

  final UserViewModel _userViewModel = UserViewModel();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue, // AppBar color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Drawer header color
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'), // Profile image
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'role',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            FutureBuilder<bool>(
              future: _userViewModel.checkRoleFromToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data == true) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_balance_wallet),
                        title: Text('My Wallet'),
                        onTap: () {
                          Navigator.pushNamed(context, '/settings'); // Go to settings page
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.home_work),
                        title: Text('My Company'),
                        onTap: () {
                          Navigator.pushNamed(context, '/mycompany'); // Go to company page
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.verified),
                        title: Text('Activation'),
                        onTap: () {
                          Navigator.pushNamed(context, '/activation'); // Go to activation page
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasData && snapshot.data == false) {
                  return Container(); // Return an empty container if access is denied
                } else {
                  return Text('Error checking role');
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings'); // Go to about page
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Logout logic
                _userRepository.logout();
                Navigator.pushNamed(context, '/'); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
