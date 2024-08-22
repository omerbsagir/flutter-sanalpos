import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_snackbar.dart';
import '/viewmodels/user_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş'),
          automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Posta'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                if (emailController.text.isEmpty) {
                  CustomSnackbar.show(context,'E-Posta Alanı Boş Bırakılamaz',Colors.orange);
                } else if (passwordController.text.isEmpty) {
                  CustomSnackbar.show(context,'Şifre Alanı Boş Bırakılamaz',Colors.orange);
                } else {
                  HapticFeedback.heavyImpact();
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
              child: const Text('Giriş'),
            ),
            const SizedBox(height : 10),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.pushNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
