// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final int age;
  final double weight; // in kg
  final String? profilePictureUrl;
  final bool biometricEnabled;
  final String? city; // for weather

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.age,
    required this.weight,
    this.profilePictureUrl,
    this.biometricEnabled = false,
    this.city,
  });

  // Weight category helper
  String get weightCategory {
    final bmi = weight / ((age > 0 ? 1.7 : 1.7) * 1.7); // simplified
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  String get ageGroup => age >= 50 ? 'senior' : 'young';

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      age: (map['age'] ?? 25).toInt(),
      weight: (map['weight'] ?? 60.0).toDouble(),
      profilePictureUrl: map['profilePictureUrl'],
      biometricEnabled: map['biometricEnabled'] ?? false,
      city: map['city'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'age': age,
      'weight': weight,
      'profilePictureUrl': profilePictureUrl,
      'biometricEnabled': biometricEnabled,
      'city': city,
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    int? age,
    double? weight,
    String? profilePictureUrl,
    bool? biometricEnabled,
    String? city,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      city: city ?? this.city,
    );
  }
}
