import 'dart:io';

import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/features/authentication/models/users/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
      if (kDebugMode) {
        print("==== new user entered======");
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong . Please try again';
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      // final snapshotDocument = await _db
      //     .collection("Users")
      //     .doc('EyTbtgIxRwamzlhsPnSs4lehlcc2')
      //     .get();

      final snapshotDocument = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();

      if (snapshotDocument.exists) {
        if (kDebugMode) {
          print("====fetch user  ======");
          print(snapshotDocument.data().toString());
        }
        return UserModel.fromSnapshot(snapshotDocument);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return UserModel.empty();
    }
  }

  Future<void> updateUserDetails(UserModel user) async {
    try {
      // await _db
      //     .collection("Users")
      //     .doc('EyTbtgIxRwamzlhsPnSs4lehlcc2')
      //     .update(user.toJson());
      await _db.collection("Users").doc(user.id).update(user.toJson());
      if (kDebugMode) {
        print("====  user updated======");
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateSingleFieldUser(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          // .doc('EyTbtgIxRwamzlhsPnSs4lehlcc2')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
      if (kDebugMode) {
        print("====  user updated======");
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
      if (kDebugMode) {
        print("====  user removed======");
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'errore in upload file';
    }
  }
}
