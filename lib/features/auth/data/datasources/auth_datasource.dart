import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/features/auth/data/models/user_model.dart';

class AuthDatasource {
  final String collection = 'users';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user
  Future<void> createUser(UserModel user) async {
    await _firestore.collection(collection).doc(user.id).set(user.toJson());
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(collection).doc(user.id).update(user.toJson());
  }

  // Get user by id
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection(collection).doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromFirestore(doc.data()!, doc.id);
  }
}
