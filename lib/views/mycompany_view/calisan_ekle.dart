import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '../../models/user_model.dart';
import '../widgets/custom_snackbar.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';

class CalisanEkleScreen extends StatefulWidget {
  @override
  _CalisanEkleScreenState createState() => _CalisanEkleScreenState();
}

class _CalisanEkleScreenState extends State<CalisanEkleScreen> {


  final TextEditingController emailController = TextEditingController();
  String fullPhoneNumber = '';
  final TextEditingController passwordController = TextEditingController();


  final UserViewModel userViewModel=UserViewModel();
  final CompanyAndActivationViewModel companyAndActivationViewModel = CompanyAndActivationViewModel();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Çalışan Ekle'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                  await userViewModel.registerNewUser(newUser);

                  final response = userViewModel.userResponse;
                  if (response.status == Status.COMPLETED) {
                    CustomSnackbar.show(context,'Çalışan Kaydı Başarılı',Colors.green);
                    Navigator.pushNamed(context, '/mycompany');
                  } else {
                    CustomSnackbar.show(context,'Çalışan Kaydı Başarısız',Colors.red);
                  }
                }

              },
            child: Text('Çalışan Ekle'),
          ),
          ],
        ),
      ),

    );
  }


}
