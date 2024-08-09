import 'package:flutter/material.dart';
import 'package:flutterprojects/data/remote/response/api_response.dart';
import 'package:provider/provider.dart';
import '/viewmodels/user_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'Email alanı boş bırakılamaz',
                          style: TextStyle(color: Colors.white), // Yazı rengi
                          textAlign: TextAlign.center, // Yazıyı ortalar
                        ),
                      ),
                      backgroundColor: Colors.blueGrey, // Arka plan rengi
                      behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // Yuvarlak köşe
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
                    ),
                  );
                } else if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'Şifre alanı boş bırakılamaz',
                          style: TextStyle(color: Colors.white), // Yazı rengi
                          textAlign: TextAlign.center, // Yazıyı ortalar
                        ),
                      ),
                      backgroundColor: Colors.blueGrey, // Arka plan rengi
                      behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ), // Yuvarlak köşe
                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
                    ),
                  );
                } else {

                  await userViewModel.login(
                    emailController.text,
                    passwordController.text,
                  );

                  final response = userViewModel.userResponse;
                  if (response.status == Status.COMPLETED) {

                    Navigator.pushNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            'Giriş Başarısız',
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
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Yeşil renk
              ),
              child: Text('Login'),
            ),
            SizedBox(height : 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Go back to Register'),
            ),
          ],
        ),
      ),
    );
  }
}
