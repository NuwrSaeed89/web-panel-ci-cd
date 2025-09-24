import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardingModel {
  String title;
  String arabicTitle;
  String subTitle;
  String arabicSubtitle;
  String image;

  OnBoardingModel(
      {required this.title,
      required this.arabicTitle,
      required this.arabicSubtitle,
      required this.subTitle,
      required this.image});
  static OnBoardingModel empty() => OnBoardingModel(
      title: '', arabicTitle: '', arabicSubtitle: '', subTitle: '', image: '');
  toJson() {
    return {
      'Title': title,
      'SubTitle': subTitle,
      'ArabicTitle': arabicTitle,
      'ArabicSubTitle': arabicSubtitle,
      'Image': image
    };
  }

  factory OnBoardingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return OnBoardingModel.empty();
    final data = document.data()!;

    return OnBoardingModel(
      title: data['Title'] ?? '',
      subTitle: data['SubTitle'] ?? '',
      arabicTitle: data['ArabicTitle'] ?? '',
      arabicSubtitle: data['ArabicSubTitle'] ?? '',
      image: data['Image'] ?? '',
    );
  }
}
