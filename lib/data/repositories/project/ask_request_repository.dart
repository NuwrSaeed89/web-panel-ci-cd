import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brother_admin_panel/data/models/ask_request_model.dart';

class AskRequestRepository {
  static AskRequestRepository get instance => AskRequestRepository._internal();
  AskRequestRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'AskPrices'; // إصلاح: استخدام المجموعة الصحيحة

  // جلب جميع طلبات التسعير
  Future<List<AskRequestModel>> fetchAllPriceRequests() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('DateTime', descending: true)
          .get();

      final requests = snapshot.docs.map((doc) {
        return AskRequestModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).where((request) {
        final isValid = request.id.isNotEmpty;
        if (!isValid) {}
        return isValid;
      }).toList();

      return requests;
    } catch (e) {
      rethrow;
    }
  }

  // تحديث طلب التسعير
  Future<void> updatePriceRequest(AskRequestModel request) async {
    try {
      await _firestore.collection(_collection).doc(request.id).update({
        'State': request.state,
        'ProposedPrice': request.proposedPrice,
        'UpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // جلب تفاصيل المستخدم
  Future<Map<String, String>> fetchUserDetailsById(String userId) async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return {
          'fullName': userData['fullName'] ?? 'مستخدم غير معروف',
          'email': userData['email'] ?? '',
          'phone': userData['phone'] ?? '',
        };
      }
      return {
        'fullName': 'مستخدم غير معروف',
        'email': '',
        'phone': '',
      };
    } catch (e) {
      return {
        'fullName': 'مستخدم غير معروف',
        'email': '',
        'phone': '',
      };
    }
  }
}
