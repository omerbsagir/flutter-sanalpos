import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import '/views/widgets/custom_scaffold.dart'; // CustomScaffold'ı import edin

class CalisanEkleScreen extends StatefulWidget {
  @override
  _CalisanEkleScreenState createState() => _CalisanEkleScreenState();
}

class _CalisanEkleScreenState extends State<CalisanEkleScreen> {


  final TextEditingController email2IdController = TextEditingController();
  final TextEditingController phone2Id2Controller = TextEditingController();
  final TextEditingController password2Id2Controller = TextEditingController();


  final UserViewModel userViewModel=UserViewModel();
  final CompanyAndActivationViewModel companyAndActivationViewModel = CompanyAndActivationViewModel();

  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

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
            controller: email2IdController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: phone2Id2Controller,
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          TextField(
            controller: password2Id2Controller,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await userViewModel.registerNewUser(email2IdController.text,phone2Id2Controller.text,password2Id2Controller.text);

              final response = userViewModel.userResponse;
              if (response.status == Status.COMPLETED) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Çalışan Kaydı başarılı')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.error ?? 'Çalışan Kaydı başarısız!')),
                );
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
