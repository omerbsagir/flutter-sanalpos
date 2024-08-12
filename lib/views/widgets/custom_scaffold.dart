import 'package:flutter/material.dart';
import 'package:flutterprojects/repositories/user_repository.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:flutterprojects/viewmodels/company_and_activation_viewmodel.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<IconButton>? actions; // Make actions optional

  CustomScaffold({required this.body, required this.title, this.actions});

  final UserViewModel _userViewModel = UserViewModel();
  final CompanyAndActivationViewModel _companyAndActivationViewModel = CompanyAndActivationViewModel();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: actions,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: SingleChildScrollView( // Make content scrollable if needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      // backgroundImage: , // Add the image provider here
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<dynamic>(
                      future: _companyAndActivationViewModel.getCompanyForNavBar(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return Text(
                            _companyAndActivationViewModel.companyName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data == false) {
                          return Text(
                            'Your Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    FutureBuilder<dynamic>(
                      future: _userViewModel.getRoleFromToken(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 10,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data == false) {
                          return SizedBox.shrink(); // To avoid empty space
                        } else {
                          return Text(
                            'Error getting user role',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
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
                          Navigator.pushNamed(context, '/mywallet');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.home_work),
                        title: Text('My Company'),
                        onTap: () {
                          Navigator.pushNamed(context, '/mycompany');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.verified),
                        title: Text('Activation'),
                        onTap: () {
                          Navigator.pushNamed(context, '/activation');
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasData && snapshot.data == false) {
                  return SizedBox.shrink();
                } else {
                  return Text('Error checking role');
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _userRepository.logout();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
