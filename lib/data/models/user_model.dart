import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.role,
    required super.fullName,
    required super.dateOfBirth,
    required super.gender,
    required super.nik,
    super.medicalHistory,
    super.hospitalInstance,
  });

  // Convert Firebase document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? '',
      fullName: map['fullName'] ?? '',
      dateOfBirth:
          map['dateOfBirth'] != null
              ? (map['dateOfBirth'] as Timestamp).toDate()
              : null,
      gender: map['gender'] ?? '',
      nik: map['nik'] ?? '',
      medicalHistory: map['medicalHistory'],
      hospitalInstance: map['hospitalInstance'],
    );
  }

  // Convert UserModel to Firebase map
  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "phoneNumber": phoneNumber,
      "role": role,
      "fullName": fullName,
      "dateOfBirth":
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      "gender": gender,
      "nik": nik,
      "medicalHistory": medicalHistory,
      "hospitalInstance": hospitalInstance,
    };
  }
}
