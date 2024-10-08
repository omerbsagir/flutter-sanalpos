import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '../widgets/custom_snackbar.dart';
import '/viewmodels/company_and_activation_viewmodel.dart';
import '/viewmodels/wallet_viewmodel.dart';
import '/views/widgets/custom_scaffold.dart';


class MyCompanyScreen extends StatefulWidget {
  const MyCompanyScreen({super.key});

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

  final UserViewModel userViewModel = UserViewModel();
  final WalletViewModel walletViewModel = WalletViewModel();

  List<dynamic> lastUsersForAdmin = [];
  int listLenght = 0;
  int lastUsersForAdminsLenght = 0;
  bool isFirstLoad = true;
  bool afterDelete = false;



  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    final companyAndActivationViewModel = Provider.of<
        CompanyAndActivationViewModel>(context, listen: false);

    if (isFirstLoad) {
      lastUsersForAdminsLenght = 0;
      isFirstLoad = false;
    }
    else {
      lastUsersForAdminsLenght =
          companyAndActivationViewModel.usersForAdmin.length;
    }
    if (afterDelete) {
      await companyAndActivationViewModel.getUsersAdmin();
      lastUsersForAdminsLenght = companyAndActivationViewModel.usersForAdmin.length;
      afterDelete = false;
    }


    companyAndActivationViewModel.usersForAdmin.clear();
    companyAndActivationViewModel.companyDetails.clear();

    await companyAndActivationViewModel.getCompany();
    await companyAndActivationViewModel.getUsersAdmin();

    setState(() {
      listLenght = companyAndActivationViewModel.usersForAdmin.length;
    });
  }

  Future<void> _confirmDeleteWorker(String email) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text('İşlemi Onayla'),
            content: const Text('Çalışan kaydını silmek istediğine emin misin?'),
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
          return AlertDialog(
            title: const Text('İşlemi Onayla'),
            content: const Text('Çalışan kaydını silmek istediğine emin misin?'),
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
      await userViewModel.deleteUser(email);
      await companyAndActivationViewModel.getUsersAdmin();
      setState(() {
        CustomSnackbar.show(context, 'Çalışan Başarıyla Silindi', Colors.green);
        Navigator.pushReplacementNamed(context, '/mycompany');
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context);

    return CustomScaffold(
      title: 'Şirketim',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.pushReplacementNamed(context, '/mycompany');
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!companyAndActivationViewModel.isCompanyLoaded) ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Şirket İsmi '),
              ),
              TextField(
                controller: ibanController,
                decoration: const InputDecoration(labelText: 'IBAN'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty || ibanController.text.isEmpty) {
                    CustomSnackbar.show(context, 'Hiçbir Alan Boş Bırakılamaz', Colors.orange);
                  } else if (!(nameController.text.length > 2 && nameController.text.length < 8)) {
                    CustomSnackbar.show(context, 'Şirket İsmi 3 ile 8 Karakter Arası Olmalıdır!', Colors.orange);
                  } else if (!ibanController.text.startsWith('TR') || ibanController.text.length != 26) {
                    CustomSnackbar.show(context, 'Lütfen Geçerli Bir IBAN Girin!', Colors.orange);
                  } else {
                    await companyAndActivationViewModel.createCompany(
                        nameController.text, ibanController.text);

                    final response = companyAndActivationViewModel.company_and_activationResponse;
                    if (response.status == Status.COMPLETED) {
                      CustomSnackbar.show(context, 'Şirket Kaydı Başarılı', Colors.green);
                    } else {
                      CustomSnackbar.show(context, 'Şirket Kaydı Başarısız', Colors.red);
                    }
                    final resp = await walletViewModel.createWallet();
                    if (resp.status == Status.COMPLETED) {
                      CustomSnackbar.show(context, 'Cüzdan Kaydı Başarılı', Colors.green);
                      Navigator.pushNamed(context, '/mycompany');
                    } else {
                      CustomSnackbar.show(context, 'Cüzdan Kaydı Başarısız', Colors.red);
                    }
                    nameController.clear();
                    ibanController.clear();
                  }
                },
                child: const Text('Şirketi Kaydet'),
              ),
            ] else ...[
              Consumer<CompanyAndActivationViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.company_and_activationResponse.status == Status.LOADING) {
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
                  } else if (viewModel.company_and_activationResponse.status == Status.COMPLETED) {
                    final companyDetails = viewModel.companyDetails;
                    final userDetails = viewModel.usersForAdmin;
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (companyDetails.isNotEmpty) ...[

                            Row(
                              children: [
                                const SizedBox(width: 35,),
                                const Icon(
                                  Icons.home_work_sharp,
                                  color: Colors.black54,
                                  size: 120,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRowName(companyDetails[0]),
                                      //_buildInfoRow('IBAN', companyDetails[1]),
                                      _buildInfoRow('Çalışan Sayısı', listLenght.toString()),
                                      _buildActivationStatusRow(companyDetails[2]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            const Text('Şirket bilgileri bulunamadı.', style: TextStyle(color: Colors.grey)),
                          ],
                          const SizedBox(height: 20),
                          const Divider(thickness: 0.75,color: Colors.black,),
                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [

                                const Expanded(
                                  child :
                                  Text(
                                    '    Çalışanların',
                                    style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.w400,color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                IconButton(
                                  icon:const Icon(Icons.person_add),
                                  onPressed: () async {
                                    HapticFeedback.heavyImpact();
                                    Navigator.pushNamed(context, '/calisanekle');
                                  },
                                ),

                              ],
                            ),
                          ),

                          if (userDetails.isNotEmpty) ...[

                            const SizedBox(height: 20),

                            if (lastUsersForAdminsLenght != 0 && !isFirstLoad) ...[
                              if (lastUsersForAdminsLenght <= userDetails.length) ...[
                                for (int i = lastUsersForAdminsLenght; i < userDetails.length; i++)
                                  _buildInfoColumn2(userDetails[i]),
                              ],
                            ]
                            else if (lastUsersForAdminsLenght == 0) ...[
                              for (int i = 0; i < userDetails.length; i++)
                                _buildInfoColumn2(userDetails[i]),
                            ],
                          ] else ...[
                            const Text('Hiçbir kullanıcı mevcut değil.', style: TextStyle(color: Colors.grey)),
                          ],
                        ],
                      ),
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


  Widget _buildInfoRow(String title, String value) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4), // Add some space between title and value
              Text(
                value,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
    );
  }
  Widget _buildInfoRowName(String value) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
                color: Colors.red
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn2(String email) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 10,),
            const Icon(
              Icons.person,
              size: 15,
            ),
            // Email
            Expanded(
              child: Text(
                email,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            // Delete Icon
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                HapticFeedback.heavyImpact();
                _confirmDeleteWorker(email); // Pass email to delete function
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivationStatusRow(bool isActive) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Aktivasyon Durumu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4), // Metin ile ikon arasında boşluk
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

}