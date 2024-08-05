import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import 'package:flutterprojects/views/widgets/custom_scaffold.dart'; // CustomScaffold'ı import edin

class MyCompanyScreen extends StatefulWidget {
  @override
  _MyCompanyScreenState createState() => _MyCompanyScreenState();
}

class _MyCompanyScreenState extends State<MyCompanyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController ownerId2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    //await companyAndActivationViewModel.getCompany('8066b334-af7c-48a0-87cf-fad57e5436ed');
    await companyAndActivationViewModel.getCompany('deneme');
  }

  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return CustomScaffold(
      title: 'My Company',
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!companyAndActivationViewModel.isCompanyLoaded) ...[
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
                  await companyAndActivationViewModel.createCompany(nameController.text, ownerIdController.text, ibanController.text);

                  final response = companyAndActivationViewModel.company_and_activationResponse;
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
            ] else ...[
              Consumer<CompanyAndActivationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.company_and_activationResponse.status == Status.LOADING) {
                    return Center(child: CircularProgressIndicator());
                  } else if (viewModel.company_and_activationResponse.status == Status.COMPLETED) {
                    final companyDetails = viewModel.companyDetails;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (companyDetails.isNotEmpty) ...[
                          _buildInfoCard('Name', companyDetails[0]),
                          _buildInfoCard('IBAN', companyDetails[1]),
                          _buildInfoCard('Activation Status', companyDetails[2].toString()),
                        ] else ...[
                          Text('No company details available.', style: TextStyle(color: Colors.grey)),
                        ],
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'An error occurred.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontSize: 14)),
              SizedBox(height: 8.0),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
