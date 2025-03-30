class SignupState {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String fullName;
  final String dob;
  final String gender;
  final String ktp;
  final String medicalHistory;
  final String hospitalInstance;

  SignupState({
    this.username = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.role = '',
    this.fullName = '',
    this.dob = '',
    this.gender = '',
    this.ktp = '',
    this.medicalHistory = '',
    this.hospitalInstance = '',
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? phone,
    String? password,
    String? role,
    String? fullName,
    String? dob,
    String? gender,
    String? ktp,
    String? medicalHistory,
    String? hospitalInstance,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      ktp: ktp ?? this.ktp,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      hospitalInstance: hospitalInstance ?? this.hospitalInstance,
    );
  }
}
