import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:founded_ninu/data/models/user_model.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (userDoc.exists) {
      return UserModel.fromMap(
        userDoc.data() as Map<String, dynamic>,
        user.uid,
      );
    }
  }
  return null; // User not found
});
