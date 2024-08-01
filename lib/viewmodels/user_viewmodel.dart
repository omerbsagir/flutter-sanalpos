import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../data/remote/response/api_response.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  ApiResponse<UserModel> user = ApiResponse.loading();

  Future<void> login(String email, String password) async {
    try {
      user = ApiResponse.loading();
      notifyListeners();
      user = ApiResponse.completed(await _userRepository.login(email, password));
    } catch (e) {
      user = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> register(UserModel newUser) async {
    try {
      user = ApiResponse.loading();
      notifyListeners();
      user = ApiResponse.completed(await _userRepository.register(newUser));
    } catch (e) {
      user = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }
}
