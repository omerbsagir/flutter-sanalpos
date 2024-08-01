import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/user_viewmodel.dart';
import '/models/user_model.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                UserModel newUser = UserModel(
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                );
                await userViewModel.register(newUser);
                if (userViewModel.userResponse.status == Status.COMPLETED) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(userViewModel.userResponse.status.toString())),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
