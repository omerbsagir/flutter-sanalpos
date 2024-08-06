import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../data/remote/response/api_response.dart';
import '../services/token_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  ApiResponse<String> userResponse = ApiResponse.loading();
  UserViewModel _userViewModel = UserViewModel();

  Future<dynamic> login(String email , String password) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.login(email,password);

      userResponse = ApiResponse.completed('Login successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }

  Future<dynamic> register(UserModel newUser) async {
    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.register(newUser);

      userResponse = ApiResponse.completed('Registration successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }
  Future<dynamic> registerNewUser(String email, String phone, String password) async {
    String adminId = '';
    try{
      adminId = await _userViewModel.getUserIdFromToken();
    }catch(e){
      print(e);
    }

    try {
      userResponse = ApiResponse.loading();
      notifyListeners();

      await _userRepository.registerNewUser(email,phone,password,adminId);

      userResponse = ApiResponse.completed('Registration successful');
    } catch (e) {
      print('Hata yakalandı: $e');
      userResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners(); // UI'yi son durumu göstermek için güncelle
      return userResponse;
    }
  }

  Future<String> getUserIdFromToken() async {
    final token = await TokenService.getToken();
    final tokenMap = await TokenService.parseJwt(token.toString());

    String userId = tokenMap['userId'];

    return userId;
  }

}
