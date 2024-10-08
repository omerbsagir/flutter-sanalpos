import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/viewmodels/user_viewmodel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../data/remote/response/api_response.dart';
import '../../models/user_model.dart';
import '../widgets/custom_snackbar.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';

class CalisanEkleScreen extends StatefulWidget {
  const CalisanEkleScreen({super.key});

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
        title: const Text('Çalışan Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.of(context).pop();
          },
        ),
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
                companyAndActivationViewModel.usersForAdmin.clear();
                await companyAndActivationViewModel.getUsersAdmin();
                int lenght=0;
                lenght = companyAndActivationViewModel.usersForAdmin.length;
              
                UserModel newUser = UserModel(
                  email: emailController.text,
                  phone: fullPhoneNumber,
                  password: passwordController.text,
                );

                if (emailController.text.isEmpty || fullPhoneNumber.isEmpty || passwordController.text.isEmpty ) {
                  CustomSnackbar.show(context,'Hiçbir alan Boş Bırakılamaz',Colors.orange);
                } else if (passwordController.text.isEmpty) {
                  CustomSnackbar.show(context,'Şifre Alanı Boş Bırakılamaz',Colors.orange);
                }
                else if (lenght==5) {
                  CustomSnackbar.show(context,'En Fazla 5 Çalışanınız Olabilir!',Colors.red);
                }
                else {
                  HapticFeedback.heavyImpact();
                  await userViewModel.registerNewUser(newUser);

                  final response = userViewModel.userResponse;
                  if (response.status == Status.COMPLETED) {
                    CustomSnackbar.show(context,'Çalışan Kaydı Başarılı',Colors.green);
                    Navigator.pushNamed(context, '/mycompany');
                  } else {
                    CustomSnackbar.show(context,'Çalışan Kaydı Başarısız',Colors.red);
                  }
                }
                emailController.clear();
                fullPhoneNumber = '';
                passwordController.clear();

              },
            child: const Text('Çalışan Ekle'),
          ),
          ],
        ),
      ),

    );
  }


}
