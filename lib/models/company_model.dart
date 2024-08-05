class CompanyModel {
  final String iban;
  final String name;
  CompanyModel({


    required this.iban,
    required this.name,

  });


  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(

      iban: json['iban'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'iban':iban,
      'name': name,
    };
  }
}
