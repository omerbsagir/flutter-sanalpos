import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_pos/viewmodels/user_viewmodel.dart';
import 'package:e_pos/viewmodels/wallet_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../viewmodels/company_and_activation_viewmodel.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  Future<void> _logoutAfterDelete() async {
    final userViewModel = Provider.of<UserViewModel>(context,listen: false);

    try{
      await userViewModel.logout();

    }catch(e){
      print(e);
    }
  }
  Future<void> _confirmDeleteCompany() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);
    final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          // Use CupertinoAlertDialog for iOS
          return CupertinoAlertDialog(
            title: const Text('İşlemi Onayla'),
            content: const Text('Şirket kaydını silmek istediğine emin misin?'),
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
            content: const Text('Şirket kaydını silmek istediğine emin misin?'),
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
      List<dynamic> usersForAdmin = [];
      try {
        await companyAndActivationViewModel.getUsersAdmin();
        usersForAdmin = companyAndActivationViewModel.usersForAdmin;
      } catch (e) {
        print(e);
      }
      try {
        await walletViewModel.deleteWallet();
        await userViewModel.deleteWorkers(usersForAdmin);
        await companyAndActivationViewModel.deleteCompany();
        CustomSnackbar.show(context, 'Şirket Başarıyla Silindi', Colors.green);
      } catch (e) {
        CustomSnackbar.show(context, 'Şirket silinemedi: $e', Colors.red);
      }
    }
  }
  Future<void> _confirmDeleteUser() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);
    final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          // Use CupertinoAlertDialog for iOS
          return CupertinoAlertDialog(
            title: const Text('İşlemi Onayla'),
            content: const Text('Hesap kaydını silmek istediğine emin misin?'),
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
            content: const Text('Hesap kaydını silmek istediğine emin misin?'),
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
      try {
        await userViewModel.getUser();
        if (userViewModel.userDetails.isNotEmpty) {
          String email = userViewModel.userDetails[0];

          List<dynamic> usersForAdmin = [];
          try {
            await companyAndActivationViewModel.getUsersAdmin();
            usersForAdmin = companyAndActivationViewModel.usersForAdmin;
          } catch (e) {
            print(e);
          }

          await walletViewModel.deleteWallet();
          await companyAndActivationViewModel.deleteCompany();
          await userViewModel.deleteWorkers(usersForAdmin);
          await userViewModel.deleteUser(email);

          CustomSnackbar.show(context, 'Hesap başarıyla silindi.', Colors.green);
          _logoutAfterDelete();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      } catch (e) {
        CustomSnackbar.show(context, 'Hesap silinemedi: $e', Colors.red);
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      title: "Ayarlar",
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person_remove),
            title: const Text('Hesabı sil'),
            subtitle: const Text('Hesabını sistemden sil.'),
            onTap: () {
              Vibration.vibrate(duration: 100);
              _confirmDeleteUser();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Şirketi Sil'),
            subtitle: const Text('Şirketini sistemden sil.'),
            onTap: () {
              Vibration.vibrate(duration: 100);
              _confirmDeleteCompany();
            },
          ),
        ],
      ),
    );
  }




}
