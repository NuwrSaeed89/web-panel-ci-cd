import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BlogModel {
  // دالة لمعالجة editTime سواء كان int أو Timestamp
  static DateTime? _parseEditTime(dynamic editTime) {
    if (editTime == null) return null;

    if (editTime is int) {
      // إذا كان int (timestamp)
      return DateTime.fromMillisecondsSinceEpoch(editTime);
    } else if (editTime is Timestamp) {
      // إذا كان Timestamp
      return editTime.toDate();
    } else {
      // محاولة تحويل إلى int
      try {
        final intValue = int.parse(editTime.toString());
        return DateTime.fromMillisecondsSinceEpoch(intValue);
      } catch (e) {
        return null;
      }
    }
  }

  final String id;
  final String title;
  final String arabicTitle;
  final String auther;
  final String arabicAuther;
  final String details;
  final String arabicDetails;
  final bool active;
  final List<String>? images;
  final DateTime? editTime;

  BlogModel(
      this.id,
      this.title,
      this.arabicTitle,
      this.auther,
      this.arabicAuther,
      this.details,
      this.arabicDetails,
      this.active,
      this.images,
      this.editTime);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicTitle': arabicTitle,
      'auther': auther,
      'arabicAuther': arabicAuther,
      'details': details,
      'arabicDetails': arabicDetails,
      'Active': active,
      'images': images,
      'editTime': editTime?.millisecondsSinceEpoch,
    };
  }

  factory BlogModel.fromSnapshot(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    return BlogModel(
      map['id'] ?? snapshot.id,
      map['title'] ?? '',
      map['arabicTitle'] ?? '',
      map['auther'] ?? '',
      map['arabicAuther'] ?? '',
      map['details'] ?? '',
      map['arabicDetails'] ?? '',
      map['Active'] ?? true,
      map['images'] != null ? List<String>.from(map['images']) : [],
      _parseEditTime(map['editTime']),
    );
  }
}
