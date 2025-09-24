import 'package:brother_admin_panel/data/models/project_model.dart';

import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProjectRepository extends GetxController {
  static ProjectRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<String> addProject(ProjectModel project) async {
    try {
      project.uId == AuthenticationRepository.instance.authUser!.uid;

      await _db.collection('Projects').add(project.toJson());

      return 'added succesfully';
    } catch (e) {
      throw 'Some thing wrong while saving project';
    }
  }

  Future<List<ProjectModel>> fetchUserProjects() async {
    try {
      final userId = //'w0xDf8Cau2aqJrcH8vaaRYASY4I2';
          AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. try again later';
      }
      final snapshot = await _db
          .collection("Projects")
          .where('UId', isEqualTo: userId)
          .get();
      return snapshot.docs.map(ProjectModel.fromSnapshot).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw 'Something wrong while get Project data';
    }
  }

  // جلب جميع المشاريع
  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      final snapshot = await _db.collection("Projects").get();

      final projects = snapshot.docs.map((e) {
        return ProjectModel.fromSnapshot(e);
      }).toList();

      return projects;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw 'Something wrong while getting all projects';
    }
  }

  // تحديث المشروع
  Future<void> updateProject(ProjectModel project) async {
    try {
      await _db.collection("Projects").doc(project.id).update(project.toJson());
      if (kDebugMode) {
        print("==== Project updated successfully =====");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw 'Something wrong while updating project';
    }
  }

  // جلب تفاصيل المستخدم بواسطة ID
  Future<Map<String, String>> fetchUserDetailsById(String userId) async {
    try {
      final doc = await _db.collection("Users").doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return {
          'firstName': data['FirstName'] ?? '',
          'lastName': data['LastName'] ?? '',
          'fullName':
              '${data['FirstName'] ?? ''} ${data['LastName'] ?? ''}'.trim(),
        };
      }
      return {'firstName': '', 'lastName': '', 'fullName': 'Unknown User'};
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'firstName': '', 'lastName': '', 'fullName': 'Unknown User'};
    }
  }
}
