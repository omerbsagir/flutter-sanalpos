import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/company_and_activation_viewmodel.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:vibration/vibration.dart';
import '../widgets/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {

  //final UserViewModel _userViewModel = UserViewModel();
  

  
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
              _confirmDeleteUser(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Delete Company'),
            subtitle: Text('Remove your company from the system'),
            onTap: () {
              _confirmDeleteCompany(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete your user account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await DeleteUser(context);
                CustomSnackbar.show(context, 'User deleted successfully.',Colors.green);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCompany(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Company'),
          content: Text('Are you sure you want to delete your company? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await DeleteCompany(context);
                CustomSnackbar.show(context, 'Company deleted successfully.',Colors.green);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> DeleteUser(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    await userViewModel.getUser();
    String email = userViewModel.userDetails[0];
    await userViewModel.deleteUser(email);

  }
  Future<void> DeleteCompany(BuildContext context) async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    await companyAndActivationViewModel.deleteCompany();

  }

}
