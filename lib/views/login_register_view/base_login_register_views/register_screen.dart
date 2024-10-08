import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/data/remote/response/api_response.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_snackbar.dart';
import '/viewmodels/user_viewmodel.dart';
import '/models/user_model.dart';


class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String fullPhoneNumber = '';

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
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
            const SizedBox(height: 10,),
            IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
              ),
              initialCountryCode: 'TR',
              onChanged: (phone) {
                fullPhoneNumber = '+${phone.countryCode}${phone.number}';
              },

            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                UserModel newUser = UserModel(
                  email: emailController.text,
                  phone: fullPhoneNumber,
                  password: passwordController.text,
                );

                if (emailController.text.isEmpty || fullPhoneNumber.isEmpty || passwordController.text.isEmpty ) {
                  CustomSnackbar.show(context,'Hiçbir Alan Boş Bırakılamaz',Colors.orange);
                } else if (passwordController.text.isEmpty) {
                  CustomSnackbar.show(context,'Şifre Alanı Boş Bırakılamaz',Colors.orange);
                } else {
                  HapticFeedback.heavyImpact();
                  await userViewModel.register(newUser);

                  final response = userViewModel.userResponse;
                  if (response.status == Status.COMPLETED) {
                    CustomSnackbar.show(context,'Kayıt Başarılı',Colors.green);
                    Navigator.pushNamed(context, '/login');
                  } else {
                    CustomSnackbar.show(context,'Kayıt Başarısız',Colors.red);
                  }
                }

              },
              child: const Text('Kayıt Ol'),
            ),
            const SizedBox(height : 10),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),

    );
  }
}
