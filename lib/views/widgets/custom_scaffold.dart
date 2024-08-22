import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/repositories/user_repository.dart';
import 'package:e_pos/viewmodels/user_viewmodel.dart';
import 'package:e_pos/viewmodels/company_and_activation_viewmodel.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<IconButton>? actions; // Make actions optional

  CustomScaffold({super.key, required this.body, required this.title, this.actions});

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
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: SingleChildScrollView( // Make content scrollable if needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/a.png'),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<dynamic>(
                      future: _companyAndActivationViewModel.getCompanyForNavBar(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return Text(
                            _companyAndActivationViewModel.companyName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data == false) {
                          return const Text(
                            'Adın',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text(
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
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data,
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 10,
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data == false) {
                          return const SizedBox.shrink(); // To avoid empty space
                        } else {
                          return const Text(
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
              leading: const Icon(Icons.home),
              title: const Text('Ana Sayfa'),
              onTap: () {
                HapticFeedback.heavyImpact();
                Navigator.pushNamed(context, '/home');
              },
            ),
            FutureBuilder<bool>(
              future: _userViewModel.checkRoleFromToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data == true) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('Cüzdanım'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/mywallet');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.home_work),
                        title: const Text('Şirketim'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/mycompany');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.verified),
                        title: const Text('Aktivasyon'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/activation');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Ayarlar'),
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasData && snapshot.data == false) {
                  return const SizedBox.shrink();
                } else {
                  return const Text('Rol alınamadı');
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış'),
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