import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:flutterprojects/viewmodels/company_and_activation_viewmodel.dart';
import '../widgets/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserViewModel _userViewModel = UserViewModel();
  final CompanyAndActivationViewModel _companyAndActivationViewModel = CompanyAndActivationViewModel();


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title:'Home',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Adds some spacing between the text and the button
            ElevatedButton(
              onPressed: () async {
                try {
                  String response = await _userViewModel.getUserIdFromToken();
                  print(response);
                } catch (e) {
                  print('Error accessing protected endpoint: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
              ),
              child: Text('Get User Id'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String response = await _companyAndActivationViewModel.getCompanyId();
                  print('butondan {$response}');
                } catch (e) {
                  print('Error accessing protected endpoint: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
              ),
              child: Text('Get Company Id'),
            ),
          ],
        ),
      ),
    );
  }
}
