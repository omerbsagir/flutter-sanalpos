import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';


class ActivationScreen extends StatelessWidget {
  final TextEditingController ownerIdController = TextEditingController(); // şimdilik
  final TextEditingController companyIdController = TextEditingController(); // şimdilik
  final TextEditingController tcNoController = TextEditingController();
  final TextEditingController vergiNoController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

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
              controller: ownerIdController,
              decoration: InputDecoration(labelText: 'owner ID ama değişecek!!!'),
            ),
            TextField(
              controller: companyIdController,
              decoration: InputDecoration(labelText: 'Company ID ama değişecek!!!'),
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

                await company_and_activationViewModel.createActivation(ownerIdController.text,companyIdController.text,tcNoController.text,vergiNoController.text);

                final response = company_and_activationViewModel.company_and_activationResponse;
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
              decoration: InputDecoration(labelText: 'User Id'), // şimdilik !!
            ),
            ElevatedButton(
              onPressed: () async {
                await company_and_activationViewModel.checkActiveStatus(userIdController.text);
              },
              child: Text('Check Active Status'),
            ),
            SizedBox(height: 20),
            Consumer<CompanyAndActivationViewModel>(
              builder: (context, viewModel, child) {
                final isActive = viewModel.checkActiveResponseValueFonk;
                if (isActive != false && isActive != true) {
                  return CircularProgressIndicator();
                } else if (isActive == false) {
                  return Icon(
                    Icons.cancel,
                    color:Colors.red,
                    size: 40,
                  );

                }else if (isActive == true) {
                  return Icon(
                    Icons.check_circle,
                    color:Colors.green,
                    size: 40,
                  );
                }
                else {
                  return Text('Status kontrolü sırasında bir hata oluştu');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
