import 'package:brother_admin_panel/utils/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AskRequestModel {
  final String id;
  String? uId;
  final String title;
  String? description;
  String? quantity;
  String? address;
  String? state;
  final DateTime? dateTime;
  final DateTime? estimatedDate;
  String? location;
  String? company;
  String? phoneNumber;
  String? productionBlueprints;
  String? projectCategory;
  String? assembly1;
  String? assembly2;
  double? proposedPrice;
  String? description1;
  bool? confirmation;
  List<String>? files;

  // User information fields
  String? userFullName;
  String? userEmail;
  String? userFirstName;
  String? userLastName;

  AskRequestModel({
    required this.id,
    required this.uId,
    required this.title,
    required this.state,
    this.description,
    this.quantity,
    this.address,
    this.projectCategory = '',
    this.dateTime,
    this.estimatedDate,
    this.location,
    this.files,
    this.confirmation,
    this.description1,
    this.assembly1,
    this.assembly2,
    this.company,
    this.phoneNumber,
    this.productionBlueprints,
    this.proposedPrice,
    this.userFullName,
    this.userEmail,
    this.userFirstName,
    this.userLastName,
  });
  String get formattedStartDate => THelperFunctions.getFormattedDate(dateTime!);
  static AskRequestModel empty() => AskRequestModel(
        id: '',
        uId: '',
        title: '',
        state: '',
        address: '',
        quantity: '',
        description: '',
        projectCategory: '',
        estimatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        dateTime: DateTime.fromMillisecondsSinceEpoch(0),
        location: '',
        assembly1: '',
        assembly2: '',
        company: '',
        confirmation: false,
        description1: '',
        files: [],
        phoneNumber: '',
        productionBlueprints: '',
        proposedPrice: 0,
        userFullName: '',
        userEmail: '',
        userFirstName: '',
        userLastName: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'UId': uId ?? '',
      'State': state ?? '',
      'Title': title,
      'Description': description ?? '',
      'Quantity': quantity ?? '',
      'Address': address ?? '',
      'DateTime': DateTime.now(),
      'EstimatedDate': estimatedDate ?? DateTime.fromMillisecondsSinceEpoch(0),
      'Location': location ?? '',
      'Company': company ?? '',
      'PhoneNumber': phoneNumber ?? '',
      'ProductionBlueprints': productionBlueprints ?? '',
      'ProjectCategory': projectCategory ?? '',
      'Assembly1': assembly1 ?? '',
      'Assembly2': assembly2 ?? '',
      'ProposedPrice': proposedPrice ?? '',
      'Description1': description1 ?? '',
      'Confirmation': confirmation ?? false,
      'Files': files ?? []
    };
  }

  factory AskRequestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return AskRequestModel(
        id: document.id, // إصلاح: استخدام document.id بدلاً من data['Id']
        uId: data['UId'] ?? '',
        state: data['State'] ?? '',
        title: data['Title'] ?? '',
        description: data['Description'] ?? '',
        description1: data['Description1'] ?? '',
        quantity: data['Quantity'] ?? '',
        address: data['Address'] ?? '',
        assembly1: data['Assembly1'] ?? '',
        assembly2: data['Assembly2'] ?? '',
        company: data['Company'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        location: data['Location'] ?? '',
        proposedPrice: data['ProposedPrice'] ?? 0,
        confirmation: data['Confirmation'] ?? '',
        estimatedDate: data['EstimatedDate'] != null
            ? (data['EstimatedDate'] as Timestamp).toDate()
            : DateTime.fromMillisecondsSinceEpoch(0),
        productionBlueprints: data['ProductionBlueprints'] ?? '',
        files: data['Files'] != null ? List<String>.from(data['Files']) : [],
        dateTime: (data['DateTime'] as Timestamp).toDate(),

        ///ProjectCategory

        //dateTime: (data['DateTime'] as Timestamp).toDate(),
      );
    }
    return AskRequestModel.empty();
  }

  factory AskRequestModel.fromMap(Map<String, dynamic> data) {
    return AskRequestModel(
      id: data['Id'] as String,
      uId: data['UId'] as String,
      state: data['State'] as String,
      title: data['Title'] as String,
      description: data['Description'] as String,
      quantity: data['Quantity'] as String,
      address: data['Address'] as String,
      dateTime: (data['DateTime'] as Timestamp).toDate(),
    );
  }

  factory AskRequestModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AskRequestModel(
      id: data['Id'] ?? '',
      uId: data['UId'] ?? '',
      state: data['State'] ?? '',
      title: data['Title'] ?? '',
      description: data['Description'] ?? '',
      quantity: data['Quantity'] ?? '',
      address: data['Address'] ?? '',
      dateTime: (data['DateTime'] as Timestamp).toDate(),
      estimatedDate: (data['EstimatedDate'] as Timestamp).toDate(),
      files: data['Files'] != null ? List<String>.from(data['Files']) : [],
    );
  }
}
