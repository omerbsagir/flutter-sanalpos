import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/user_viewmodel.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import '/models/user_model.dart';

class ActivationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController(); // şimdilik
  final TextEditingController ibanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final company_and_activationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Activation'),
          automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Company Name'),
            ),
            TextField(
              controller: ownerIdController,
              decoration: InputDecoration(labelText: 'Owner ID ama değişecek!!!'),
            ),
            TextField(
              controller: ibanController,
              decoration: InputDecoration(labelText: 'IBAN'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                await company_and_activationViewModel.createCompany("BKM","8066b334-af7c-48a0-87cf-fad57e5436ed","TR5990223442211231231123123");

                final response = company_and_activationViewModel.company_and_activationResponse;
                if (response.status == Status.COMPLETED) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Şirket Kaydı başarılı')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.error ?? 'Şirket Kaydı başarısız!')),
                  );
                }

              },
              child: Text('Activation'),
            ),
          ],
        ),
      ),
    );
  }
}
