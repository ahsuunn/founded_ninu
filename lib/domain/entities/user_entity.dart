class UserEntity {
  final String uid;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final String fullName;
  final DateTime? dateOfBirth;
  final String gender;
  final String nik;
  final String? medicalHistory; // Only for patients
  final String? hospitalInstance; // Only for medical officers

  UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nik,
    this.medicalHistory,
    this.hospitalInstance,
  });
}
