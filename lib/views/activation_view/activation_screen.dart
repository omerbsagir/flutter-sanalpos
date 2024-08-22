import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

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
            title: const Text('İşlemi Onayla'),
            content: const Text('Aktivasyon kaydını silmek istediğine emin misin?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('İptal'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Sil'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        } else {
          // Use AlertDialog for Android
          return AlertDialog(
            title: const Text('İşlemi Onayla'),
            content: const Text('Aktivasyon kaydını silmek istediğine emin misin?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                child: const Text('İptal'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sil'),
              ),
            ],
          );
        }
      },
    );

    if (shouldDelete == true) {
      await companyAndActivationViewModel.deleteActivation();
      CustomSnackbar.show(context, 'Aktivasyon Başarıyla Silindi', Colors.green);
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
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            HapticFeedback.heavyImpact();
            companyAndActivationViewModel.getActivation();
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!companyAndActivationViewModel.isActivationLoaded) ...[
              TextField(
                controller: tcNoController,
                decoration: const InputDecoration(labelText: 'TC No'),
              ),
              TextField(
                controller: vergiNoController,
                decoration: const InputDecoration(labelText: 'Vergi No'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (tcNoController.text.isEmpty || vergiNoController.text.isEmpty) {
                    CustomSnackbar.show(context, 'Hiçbir alan Boş Bırakılamaz', Colors.orange);
                  } else if (tcNoController.text.length != 11) {
                    CustomSnackbar.show(context, 'Lütfen Geçerli Bir TC Numarası Girin', Colors.orange);
                  } else if (vergiNoController.text.length != 10) {
                    CustomSnackbar.show(context, 'Lütfen Geçerli Bir Vergi Numarası Girin', Colors.orange);
                  } else {
                    HapticFeedback.heavyImpact();
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
                child: const Text('Aktivasyon Oluştur'),
              ),
            ] else ...[
              Consumer<CompanyAndActivationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.company_and_activationResponseAct.status == Status.LOADING) {
                    return const Center(
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
                        const SizedBox(height: 10,),
                        const Icon(
                          Icons.verified_user_sharp,
                          color: Colors.orangeAccent,
                          size: 75,
                        ),
                        const SizedBox(height: 10,),
                        const Text(
                          'ONAY DURUMU',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),

                        ),
                        const SizedBox(height: 20,),
                        const Divider(thickness: 1,color: Colors.black,),
                        const SizedBox(height: 20,),
                        if (activationDetails.isNotEmpty) ...[
                          _buildInfoColumn('TC NO', activationDetails[0]),
                          _buildInfoColumn('VERGİ NO', activationDetails[1]),
                          _buildActivationStatusColumn(activationDetails[2]),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _confirmDeleteActivation,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text(
                              'Aktivasyonu Sil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ] else ...[
                          const Text('Aktivasyon mevcut değil.', style: TextStyle(color: Colors.white)),
                        ],
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Bir hata oluştu.',
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
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
            const Text(
              'Aktivasyon Durumu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4.0),
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