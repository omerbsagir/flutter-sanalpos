import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import '/viewmodels/wallet_viewmodel.dart';
import '/views/widgets/custom_scaffold.dart';

class MyCompanyScreen extends StatefulWidget {
  @override
  _MyCompanyScreenState createState() => _MyCompanyScreenState();
}

class _MyCompanyScreenState extends State<MyCompanyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController ownerId2Controller = TextEditingController();

  final TextEditingController email2IdController = TextEditingController();
  final TextEditingController phone2Id2Controller = TextEditingController();
  final TextEditingController password2Id2Controller = TextEditingController();
  final TextEditingController adminIdId2Controller = TextEditingController();

  final UserViewModel userViewModel=UserViewModel();
  final WalletViewModel walletViewModel = WalletViewModel();

  List<dynamic> lastUsersForAdmin = [];
  int lastUsersForAdminsLenght = 0;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    if (isFirstLoad) {
      lastUsersForAdminsLenght = 0;
      isFirstLoad = false;
    }else{
      lastUsersForAdminsLenght = companyAndActivationViewModel.usersForAdmin.length;
    }

    companyAndActivationViewModel.usersForAdmin.clear();

    await companyAndActivationViewModel.getCompany();

    await companyAndActivationViewModel.getUsersAdmin();

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
                decoration: InputDecoration(labelText: 'Company Name '),
              ),

              TextField(
                controller: ibanController,
                decoration: InputDecoration(labelText: 'IBAN'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await companyAndActivationViewModel.createCompany(nameController.text,ibanController.text);

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
                  final resp = await walletViewModel.createWallet();
                  if (resp.status == Status.COMPLETED) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cüzdan Kaydı başarılı')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.error ?? 'Cüzdan Kaydı başarısız!')),
                    );
                  }
                },
                child: Text('Register the Company'),
              ),
            ] else ...[
              Consumer<CompanyAndActivationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.company_and_activationResponse.status == Status.LOADING) {
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  } else if (viewModel.company_and_activationResponse.status == Status.COMPLETED) {
                    final companyDetails = viewModel.companyDetails;

                    final userDetails = viewModel.usersForAdmin;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (companyDetails.isNotEmpty) ...[
                          _buildInfoColumn('Name', companyDetails[0]),
                          _buildInfoColumn('IBAN', companyDetails[1]),
                          _buildActivationStatusColumn(companyDetails[2]),
                        ] else ...[
                          Text('No company details available.', style: TextStyle(color: Colors.grey)),
                        ],
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/calisanekle');
                          },
                          child: Text('Register New Users'),
                        ),
                        if (userDetails.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Text(
                            'Çalışanların',
                            style: TextStyle(fontSize: 18),
                          ),
                          if(lastUsersForAdminsLenght != 0 && !isFirstLoad) ...[   //3  0 1 2

                            if(userDetails[lastUsersForAdminsLenght] != null)...[

                              for(int i=lastUsersForAdminsLenght;i<userDetails.length;i++)
                                _buildInfoColumn2(userDetails[i]),
                            ],
                          ]else if(lastUsersForAdminsLenght == 0)...[
                            for(int i=0;i<userDetails.length;i++)
                              _buildInfoColumn2(userDetails[i]),
                          ],
                        ] else ...[
                          Text('No users available.', style: TextStyle(color: Colors.grey)),
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

  Widget _buildInfoColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),

    );
  }
  Widget _buildInfoColumn2(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4.0),

          ],
        ),
      ),

    );
  }


  Widget _buildActivationStatusColumn(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Activation Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4.0),
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
              size: 30,
            ),
          ],
        ),

      ),

    );

  }


}
