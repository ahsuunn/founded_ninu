import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:founded_ninu/data/models/user_model.dart';
import 'package:founded_ninu/domain/entities/user_entity.dart';
import 'package:founded_ninu/domain/respositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserEntity user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
          UserModel(
            uid: user.uid,
            username: user.username,
            email: user.email,
            phoneNumber: user.phoneNumber,
            role: user.role,
            fullName: user.fullName,
            dateOfBirth: user.dateOfBirth,
            gender: user.gender,
            nik: user.nik,
            medicalHistory: user.medicalHistory,
            hospitalInstance: user.hospitalInstance,
          ).toMap(),
        );
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
