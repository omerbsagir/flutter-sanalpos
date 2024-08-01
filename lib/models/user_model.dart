class UserModel {
  final String? id;
  final String email;
  final String phone;
  final String password;
  final DateTime? createdAt;
  final String? role;
  final String? adminId;

  UserModel({
    this.id,
    required this.email,
    required this.phone,
    required this.password,
    this.createdAt,
    this.role,
    this.adminId
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
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
      'email': email,
      'phone':phone,
      'password': password,
      'createdAt':createdAt,
      'role':role,
      'adminId':adminId
    };
  }
}
