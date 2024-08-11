import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_snackbar.dart';
import '/viewmodels/user_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
          automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                if (emailController.text.isEmpty) {
                  CustomSnackbar.show(context,'Email Alanı Boş Bırakılamaz',Colors.orange);
                } else if (passwordController.text.isEmpty) {
                  CustomSnackbar.show(context,'Şifre Alanı Boş Bırakılamaz',Colors.orange);
                } else {

                  await userViewModel.login(
                    emailController.text,
                    passwordController.text,
                  );

                  final response = userViewModel.userResponse;
                  if (response.status == Status.COMPLETED) {
                    Navigator.pushNamed(context, '/home');
                  } else {
                    CustomSnackbar.show(context,'Giriş Başarısız',Colors.red);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Yeşil renk
              ),
              child: Text('Login'),
            ),
            SizedBox(height : 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Go back to Register'),
            ),
          ],
        ),
      ),
    );
  }
}
