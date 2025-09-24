import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  String? id;
  String? name;
  String? arabicName;
  String? text;
  String? arabicText;
  String thumbnail;
  bool isFeature;
  bool showPhoto;
  List<String>? images;

  ClientModel({
    this.id,
    this.name,
    this.arabicName,
    this.text,
    this.arabicText,
    required this.thumbnail,
    required this.isFeature,
    required this.showPhoto,
    this.images,
  });

  static ClientModel empty() =>
      ClientModel(thumbnail: '', isFeature: false, showPhoto: false);

  Map<String, dynamic> toJson() {
    return {
      'Name': name ?? '',
      'Text': text ?? '',
      'ArabicText': arabicText ?? '',
      'ArabicName': arabicName ?? '',
      'Thumbnamil': thumbnail,
      'IsFeature': isFeature,
      'showPhoto': showPhoto,
      'Images': images ?? []
    };
  }

  factory ClientModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ClientModel(
        id: document.id,
        name: data['Name'] ?? '',
        arabicName: data['ArabicName'] ?? '',
        text: data['Text'] ?? '',
        arabicText: data['ArabicText'] ?? '',
        thumbnail: data['Thumbnail'] ?? '',
        isFeature: data['IsFeature'] ?? false,
        showPhoto: data['showPhoto'] ?? false,
        images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      );
    }
    return ClientModel.empty();
  }
}
