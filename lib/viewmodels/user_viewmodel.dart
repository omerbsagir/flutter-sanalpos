class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final DateTime createdAt;
  final String role;
  final String? adminId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
    required this.role,
    required this.adminId
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      createdAt: json['createdAt'],
      role: json['role'],
      adminId: json['adminId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone':phone,
      'password': password,
      'createdAt':createdAt,
      'role':role,
      'adminId':adminId
    };
  }
}
