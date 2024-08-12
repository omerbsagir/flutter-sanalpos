import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
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

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
            SizedBox(height: 10,),
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              initialCountryCode: 'TR',
              onChanged: (phone) {
                fullPhoneNumber = '+${phone.countryCode}${phone.number}';
              },

            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                UserModel newUser = UserModel(
                  email: emailController.text,
                  phone: fullPhoneNumber,
                  password: passwordController.text,
                );

                if (emailController.text.isEmpty || fullPhoneNumber.isEmpty || passwordController.text.isEmpty ) {
                  CustomSnackbar.show(context,'Hiçbir alan Boş Bırakılamaz',Colors.orange);
                } else if (passwordController.text.isEmpty) {
                  CustomSnackbar.show(context,'Şifre Alanı Boş Bırakılamaz',Colors.orange);
                } else {
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
              child: Text('Register'),
            ),
            SizedBox(height : 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
