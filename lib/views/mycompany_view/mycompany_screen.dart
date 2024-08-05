import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';


class MyCompanyScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController(); // şimdilik
  final TextEditingController ibanController = TextEditingController();

  final TextEditingController ownerId2Controller = TextEditingController(); // şimdilik

  @override
  Widget build(BuildContext context) {
    final company_and_activationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('My Company'),
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
              child: Text('Register the Company'),
            ),
            TextField(
              controller: ownerId2Controller,
              decoration: InputDecoration(labelText: 'Owner ID ama değişecek!!!'),
            ),
            ElevatedButton(
              onPressed: () async {

                await company_and_activationViewModel.getCompany(ownerId2Controller.text);

              },
              child: Text('Şirketimi Göster'),
            ),
            Consumer<CompanyAndActivationViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.company_and_activationResponse.status == Status.LOADING) {
                  return Center(child: CircularProgressIndicator());
                } else if (viewModel.company_and_activationResponse.status == Status.COMPLETED) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${viewModel.companyDetails.isNotEmpty ? viewModel.companyDetails[0] : 'N/A'}'),
                      Text('IBAN: ${viewModel.companyDetails.isNotEmpty ? viewModel.companyDetails[1] : 'N/A'}'),
                      Text('Activation Status: ${viewModel.companyDetails.isNotEmpty ? viewModel.companyDetails[2] : 'N/A'}'),
                    ],
                  );
                } else {
                  return Text('An error occurred.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
