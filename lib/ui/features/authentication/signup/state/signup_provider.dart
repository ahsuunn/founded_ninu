import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/models/user_model.dart';
import 'signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to register the user
  Future<String?> signUp() async {
    try {
      // Create user with email and password in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: state.email,
            password: state.password,
          );

      Map<String, dynamic> userData =
          UserModel(
            uid: userCredential.user!.uid,
            username: state.username,
            email: state.email,
            phoneNumber: state.phone,
            role: state.role,
            fullName: state.fullName,
            dateOfBirth: state.dob, // Ensure this is a DateTime
            gender: state.gender,
            nik: state.ktp,
            medicalHistory: state.medicalHistory,
            hospitalInstance: state.hospitalInstance,
          ).toMap();

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      return null; // No error, sign-up successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    } catch (e) {
      return "An unexpected error occurred";
    }
  }

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

  void updateDob(DateTime dob) {
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
