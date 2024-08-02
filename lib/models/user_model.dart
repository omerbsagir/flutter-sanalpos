class UserModel {
  final String email;
  final String phone;
  final String password;
  UserModel({

    required this.email,
    required this.phone,
    required this.password,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone':phone,
      'password': password,
    };
  }
}
