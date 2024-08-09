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
        automaticallyImplyLeading: false
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


                final response = userViewModel.userResponse;
                if (response.status == Status.COMPLETED) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'Kayıt Başarılı',
                          style: TextStyle(color: Colors.white), // Yazı rengi
                          textAlign: TextAlign.center, // Yazıyı ortalar
                        ),
                      ),
                      backgroundColor: Colors.green, // Arka plan rengi
                      behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // Yuvarlak köşe
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
                    ),
                  );
                  Navigator.pushNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'Kayıt Başarısız',
                          style: TextStyle(color: Colors.white), // Yazı rengi
                          textAlign: TextAlign.center, // Yazıyı ortalar
                        ),
                      ),
                      backgroundColor: Colors.red, // Arka plan rengi
                      behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // Yuvarlak köşe
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
                    ),
                  );
                }

              },
              child: Text('Register'),
            ),
            SizedBox(height : 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
