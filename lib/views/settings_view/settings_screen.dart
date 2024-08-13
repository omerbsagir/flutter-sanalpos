import 'package:flutter/material.dart';
import 'package:flutterprojects/repositories/user_repository.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:flutterprojects/viewmodels/wallet_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/company_and_activation_viewmodel.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_snackbar.dart';

class SettingsScreen extends StatefulWidget {
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
     final walletViewModel = Provider.of<WalletViewModel>(context,listen: false);
     final userViewModel = Provider.of<UserViewModel>(context,listen: false);

     final bool? shouldDelete = await showDialog<bool>(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Confirm Delete'),
           content: Text('Are you sure you want to delete your company?'),
           actions: <Widget>[
             TextButton(
               child: Text('Cancel'),
               onPressed: () => Navigator.of(context).pop(false),
             ),
             TextButton(
               child: Text('Delete'),
               onPressed: () => Navigator.of(context).pop(true),
             ),
           ],
         );
       },
     );

     if (shouldDelete == true) {
       List<dynamic> usersForAdmin = [];
       try{
         await companyAndActivationViewModel.getUsersAdmin();
         usersForAdmin = companyAndActivationViewModel.usersForAdmin;
       }catch(e){
         print(e);
       }
       try {
         await walletViewModel.deleteWallet();
         await userViewModel.deleteWorkers(usersForAdmin);
         await companyAndActivationViewModel.deleteCompany();
         CustomSnackbar.show(context, 'Company deleted successfully', Colors.green);
       } catch (e) {
         CustomSnackbar.show(context, 'Failed to delete company: $e', Colors.red);
       }

     }
   }
  Future<void> _confirmDeleteUser() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);
    final walletViewModel = Provider.of<WalletViewModel>(context,listen: false);
    final userViewModel = Provider.of<UserViewModel>(context,listen: false);

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await userViewModel.getUser();
        if (userViewModel.userDetails.isNotEmpty) {
          String email = userViewModel.userDetails[0];

          List<dynamic> usersForAdmin = [];
          try{
            await companyAndActivationViewModel.getUsersAdmin();
            usersForAdmin = companyAndActivationViewModel.usersForAdmin;
          }catch(e){
            print(e);
          }

          await walletViewModel.deleteWallet();
          await companyAndActivationViewModel.deleteCompany();
          await userViewModel.deleteWorkers(usersForAdmin);
          await userViewModel.deleteUser(email);

          CustomSnackbar.show(context, 'Account deleted successfully.', Colors.green);
          _logoutAfterDelete();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

        }
      } catch (e) {
        CustomSnackbar.show(context, 'Failed to delete account: $e', Colors.red);
      }

    }
  }


  @override
  Widget build(BuildContext context) {

    return CustomScaffold(
      title: "Settings",
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person_remove),
            title: Text('Delete Account'),
            subtitle: Text('Remove your account from the system'),
            onTap: () {
              _confirmDeleteUser();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Delete Company'),
            subtitle: Text('Remove your company from the system'),
            onTap: () {
              _confirmDeleteCompany();
            },
          ),
        ],
      ),
    );
  }




}
