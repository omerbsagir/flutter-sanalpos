import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_scaffold.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';



class ActivationScreen extends StatefulWidget {
  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {

  final TextEditingController tcNoController = TextEditingController();
  final TextEditingController vergiNoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadActiveStatus();
  }

  Future<void> _loadActiveStatus() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    await companyAndActivationViewModel.checkActiveStatus();

  }

  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return CustomScaffold(
      title:'Aktivasyon',
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Aktif',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Pasif',
               style: TextStyle(
                 color: Colors.red,
                 fontWeight: FontWeight.bold,
               ),
            ),
          ],
        );
      }
    } else if (response.status == Status.LOADING) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Text('Durum kontrolü yapılmadı.');
    }
  }

}
