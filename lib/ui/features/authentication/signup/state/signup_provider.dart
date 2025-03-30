import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState());

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateRole(String role) {
    state = state.copyWith(role: role);
  }

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void updateDob(String dob) {
    state = state.copyWith(dob: dob);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateKtp(String ktp) {
    state = state.copyWith(ktp: ktp);
  }

  void updateMedicalHistory(String medicalHistory) {
    state = state.copyWith(medicalHistory: medicalHistory);
  }

  void updateHospitalInstance(String hospitalInstance) {
    state = state.copyWith(hospitalInstance: hospitalInstance);
  }
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((
  ref,
) {
  return SignupNotifier();
});
