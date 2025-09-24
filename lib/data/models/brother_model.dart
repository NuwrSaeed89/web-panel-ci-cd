import 'package:cloud_firestore/cloud_firestore.dart';

class BrotherModel {
  String name;
  String arabicName;
  String aboutUs;
  String arabicAboutUs;
  String cancellationPolicy;
  String arabicCancellationPolicy;
  String privacyPolicy;
  String arabicPrivacyPolicy;
  String returnPolicy;
  String arabicReturnPolicy;
  String termsCondition;
  String arabicTermsCondition;
  String? primaryColor;

  List<String> phoneNumbers;
  BrotherModel(
      {required this.name,
      required this.arabicName,
      required this.aboutUs,
      required this.arabicAboutUs,
      required this.cancellationPolicy,
      required this.arabicCancellationPolicy,
      required this.phoneNumbers,
      required this.arabicPrivacyPolicy,
      required this.privacyPolicy,
      required this.returnPolicy,
      required this.arabicReturnPolicy,
      required this.arabicTermsCondition,
      required this.primaryColor,
      required this.termsCondition});
  static BrotherModel empty() => BrotherModel(
      name: '',
      arabicName: '',
      aboutUs: '',
      arabicCancellationPolicy: '',
      arabicAboutUs: '',
      cancellationPolicy: '',
      privacyPolicy: '',
      arabicPrivacyPolicy: '',
      returnPolicy: '',
      arabicReturnPolicy: '',
      termsCondition: '',
      arabicTermsCondition: '',
      primaryColor: '',
      phoneNumbers: []);
  toJson() {
    return {
      'Name': name,
      'ArabicName': arabicName,
      'ArabicCancellationPolicy': arabicCancellationPolicy,
      'CancellationPolicy': cancellationPolicy,
      'AboutUs': aboutUs,
      'ArabicAboutUs': arabicAboutUs,
      'PhoneNumbers': phoneNumbers,
      'PrivacyPolicy': privacyPolicy,
      'ArabicPrivacyPolicy': arabicPrivacyPolicy,
      'ReturnPolicy': returnPolicy,
      'ArabicReturnPolicy': arabicReturnPolicy,
      'ArabicTermsCondition': arabicTermsCondition,
      'TermsCondition': termsCondition,
      'PrimaryColor': primaryColor
    };
  }

  factory BrotherModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return BrotherModel.empty();
    final data = document.data()!;
    return BrotherModel(
        name: data['Name'] ?? '',
        arabicName: data['ArabicName'] ?? '',
        aboutUs: data['AboutUs'] ?? '',
        arabicAboutUs: data['ArabicAboutUs'] ?? '',
        cancellationPolicy: data['CancellationPolicy'] ?? '',
        arabicCancellationPolicy: data['ArabicCancellationPolicy'] ?? '',
        phoneNumbers: data['PhoneNumbers'] != null
            ? List<String>.from(data['PhoneNumbers'])
            : [],
        privacyPolicy: data['PrivacyPolicy'] ?? '',
        arabicPrivacyPolicy: data['ArabicPrivacyPolicy'] ?? '',
        returnPolicy: data['ReturnPolicy'] ?? '',
        arabicReturnPolicy: data['ArabicReturnPolicy'] ?? '',
        termsCondition: data['TermsCondition'] ?? '',
        arabicTermsCondition: data['ArabicTermsCondition'] ?? '',
        primaryColor: data['PrimaryColor'] ?? '');
  }
}
