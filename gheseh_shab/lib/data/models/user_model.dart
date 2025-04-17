class UserModel {
  final int id;
  final String phone;
  final String password;
  final int isAdmin;
  final String firstName;
  final String lastName;
  final String? birthday;
  final String? gender;
  final String? province;
  final String? city;
  final String? country;
  final int balance;
  final String? dailyPrize;
  final String? invitedBy;
  final String? dailyRoulette;
  final String image;
  final String? rememberToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.phone,
    required this.password,
    required this.isAdmin,
    required this.firstName,
    required this.lastName,
    this.birthday,
    this.gender,
    this.province,
    this.city,
    this.country,
    required this.balance,
    this.dailyPrize,
    this.invitedBy,
    this.dailyRoulette,
    required this.image,
    this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory method to create a `UserModel` from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      password: json['password'],
      isAdmin: json['is_admin'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthday: json['birthday'],
      gender: json['gender'],
      province: json['province'],
      city: json['city'],
      country: json['country'],
      balance: json['balance'],
      dailyPrize: json['daily_prize'],
      invitedBy: json['invited_by'],
      dailyRoulette: json['daily_roulette'],
      image: json['image'],
      rememberToken: json['remember_token'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Method to convert a `UserModel` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'is_admin': isAdmin,
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'gender': gender,
      'province': province,
      'city': city,
      'country': country,
      'balance': balance,
      'daily_prize': dailyPrize,
      'invited_by': invitedBy,
      'daily_roulette': dailyRoulette,
      'image': image,
      'remember_token': rememberToken,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
