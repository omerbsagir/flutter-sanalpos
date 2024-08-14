import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';
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

    await companyAndActivationViewModel.getActivation();
    await companyAndActivationViewModel.checkActiveStatus();
  }

  Future<void> _confirmDeleteActivation() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          // Use CupertinoAlertDialog for iOS
          return CupertinoAlertDialog(
            title: Text('İşlemi Onayla'),
            content: Text('Çalışan kaydını silmek istediğine emin misin?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('İptal'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Sil'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        } else {
          // Use AlertDialog for Android
          return AlertDialog(
            title: Text('İşlemi Onayla'),
            content: Text('Çalışan kaydını silmek istediğine emin misin?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                child: Text('İptal'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Sil'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        }
      },
    );

    if (shouldDelete == true) {
      await companyAndActivationViewModel.deleteActivation();
      CustomSnackbar.show(context, 'Activation deleted successfully', Colors.green);
      await _loadActiveStatus(); // Reload data after deletion
    }
  }



  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return CustomScaffold(
      title: 'Aktivasyon',
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () {
            companyAndActivationViewModel.getActivation();
          },
        ),
      ],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!companyAndActivationViewModel.isActivationLoaded) ...[
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
                  if (tcNoController.text.isEmpty || vergiNoController.text.isEmpty) {
                    CustomSnackbar.show(context, 'Hiçbir alan Boş Bırakılamaz', Colors.orange);
                  } else if (tcNoController.text.length != 11) {
                    CustomSnackbar.show(context, 'Lütfen Geçerli Bir TC Numarası Girin', Colors.orange);
                  } else if (vergiNoController.text.length != 10) {
                    CustomSnackbar.show(context, 'Lütfen Geçerli Bir Vergi Numarası Girin', Colors.orange);
                  } else {
                    await companyAndActivationViewModel.createActivation(
                      tcNoController.text,
                      vergiNoController.text,
                    );

                    final response = companyAndActivationViewModel.company_and_activationResponse;
                    if (response.status == Status.COMPLETED) {
                      CustomSnackbar.show(context, 'Aktivasyon İsteği Başarılı', Colors.green);
                      Navigator.pushNamed(context, '/activation');
                    } else {
                      CustomSnackbar.show(context, 'Aktivasyon İsteği Başarısız', Colors.red);
                    }
                    tcNoController.clear();
                    vergiNoController.clear();
                  }
                },
                child: Text('Aktivasyon Oluştur'),
              ),
            ] else ...[
              Consumer<CompanyAndActivationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.company_and_activationResponseAct.status == Status.LOADING) {
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
                  } else if (viewModel.company_and_activationResponseAct.status == Status.COMPLETED) {
                    final activationDetails = viewModel.activationDetails;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (activationDetails.isNotEmpty) ...[
                          _buildInfoColumn('TC NO', activationDetails[0]),
                          _buildInfoColumn('VERGİ NO', activationDetails[1]),
                          _buildActivationStatusColumn(activationDetails[2]),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _confirmDeleteActivation,
                            child: Text(
                                'Delete Activation',
                                style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ] else ...[
                          Text('No activation details available.', style: TextStyle(color: Colors.white)),
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
