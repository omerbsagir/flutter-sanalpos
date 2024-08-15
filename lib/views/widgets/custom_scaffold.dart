import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: SingleChildScrollView( // Make content scrollable if needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/a.png'),
                      backgroundColor: Colors.deepPurpleAccent,
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
                            'Adın',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return Text(
                            'Hata',
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
                            'Hata',
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
              title: Text('Ana Sayfa'),
              onTap: () {
                HapticFeedback.heavyImpact();
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
                        title: Text('Cüzdanım'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/mywallet');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.home_work),
                        title: Text('Şirketim'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/mycompany');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.verified),
                        title: Text('Aktivasyon'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/activation');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Ayarlar'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasData && snapshot.data == false) {
                  return SizedBox.shrink();
                } else {
                  return Text('Rol alınamadı');
                }
              },
            ),

            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Çıkış'),
              onTap: () {
                HapticFeedback.heavyImpact();
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