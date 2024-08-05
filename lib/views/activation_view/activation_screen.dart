import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';

class ActivationScreen extends StatelessWidget {
  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController tcNoController = TextEditingController();
  final TextEditingController vergiNoController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Activation'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ownerIdController,
              decoration: InputDecoration(labelText: 'Owner ID'),
            ),
            TextField(
              controller: companyIdController,
              decoration: InputDecoration(labelText: 'Company ID'),
            ),
            TextField(
              controller: tcNoController,
              decoration: InputDecoration(labelText: 'TC No'),
            ),
            TextField(
              controller: vergiNoController,
              decoration: InputDecoration(labelText: 'Vergi No'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await companyAndActivationViewModel.createActivation(
                  ownerIdController.text,
                  companyIdController.text,
                  tcNoController.text,
                  vergiNoController.text,
                );

                final response = companyAndActivationViewModel.company_and_activationResponse;
                if (response.status == Status.COMPLETED) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Aktivasyon İsteği Başarılı')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.error ?? 'Aktivasyon İsteği Başarısız!')),
                  );
                }
              },
              child: Text('Aktivasyon Oluştur'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            ElevatedButton(
              onPressed: () async {
                await companyAndActivationViewModel.checkActiveStatus(
                    userIdController.text
                );
              },
              child: Text('Check Active Status'),
            ),
            SizedBox(height: 20),
            Consumer<CompanyAndActivationViewModel>(
              builder: (context, viewModel, child) {
                return buildStatusIcon(viewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusIcon(CompanyAndActivationViewModel viewModel) {
    final isActive = viewModel.checkActiveResponseValueFonk;
    final response = viewModel.company_and_activationResponse;

    if (response.status == Status.COMPLETED) {
      if (isActive == true) {
        return Icon(Icons.check, color: Colors.green);
      } else {
        return Icon(Icons.cancel, color: Colors.red);
      }
    } else if (response.status == Status.LOADING) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Text('Durum kontrolü yapılmadı.');
    }
  }
}
