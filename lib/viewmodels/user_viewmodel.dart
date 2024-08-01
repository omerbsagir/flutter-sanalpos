import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../data/remote/response/api_response.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  ApiResponse<String> userResponse = ApiResponse.loading();

  Future<void> login(String email, String password) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners(); // UI'yi loading durumuna güncelle

      await _userRepository.login(email, password); // UserService üzerinden login işlemi

      // Eğer işlemin başarılı olduğunu biliyorsanız, userResponse'ı güncelleyin
      userResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
    }
  }

  Future<void> register(UserModel newUser) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();
      await _userRepository.register(newUser);
      userResponse = ApiResponse.completed('Registration successful');
    } catch (e) {
      userResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
