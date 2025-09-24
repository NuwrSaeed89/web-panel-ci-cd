import 'package:brother_admin_panel/data/models/clients_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ClientsRepository extends GetxController {
  static ClientsRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<ClientModel>> getAllClients() async {
    try {
      final snapshot = await _db.collection('Clients').get();

      if (kDebugMode) {
        print("=======data=== clients===========");
        print(snapshot.docs.toString());
      }

      final list = snapshot.docs.map(ClientModel.fromSnapshot).toList();
      if (kDebugMode) {
        print("=======data==============");
        print(list);
      }
      return list;
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  // Create new client
  Future<String> createClient(ClientModel client) async {
    try {
      final docRef = await _db.collection('Clients').add(client.toJson());

      if (kDebugMode) {
        print("✅ Client created successfully with ID: ${docRef.id}");
      }

      return docRef.id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Error creating client: ${e.code}");
      }
      throw e.code;
    }
  }

  // Update existing client
  Future<void> updateClient(String clientId, ClientModel client) async {
    try {
      await _db.collection('Clients').doc(clientId).update(client.toJson());

      if (kDebugMode) {
        print("✅ Client updated successfully with ID: $clientId");
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Error updating client: ${e.code}");
      }
      throw e.code;
    }
  }

  // Delete client
  Future<void> deleteClient(String clientId) async {
    try {
      await _db.collection('Clients').doc(clientId).delete();

      if (kDebugMode) {
        print("✅ Client deleted successfully with ID: $clientId");
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("❌ Error deleting client: ${e.code}");
      }
      throw e.code;
    }
  }
}
