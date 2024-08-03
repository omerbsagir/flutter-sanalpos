import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';


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
          automaticallyImplyLeading: true
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
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                await company_and_activationViewModel.createCompany(nameController.text,ownerIdController.text,ibanController.text);

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
