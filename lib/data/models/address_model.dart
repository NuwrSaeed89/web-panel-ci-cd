import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String country;
  final String postalCode;
  String details;
  bool selectedAddress;
  final DateTime? dateTime;
  final double latitude;
  final double longitude;

  AddressModel(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.street,
      required this.city,
      required this.country,
      required this.postalCode,
      required this.latitude,
      required this.longitude,
      this.selectedAddress = true,
      this.dateTime,
      this.details = ''});

  static AddressModel empty() => AddressModel(
      id: '',
      name: '',
      city: '',
      country: '',
      selectedAddress: false,
      street: '',
      phoneNumber: '',
      postalCode: '',
      latitude: 0.0,
      longitude: 0.0,
      details: '');

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'Country': country,
      'PostalCode': postalCode,
      'SelectedAddress': selectedAddress,
      'Details': details,
      'Latitude': latitude,
      'Longitude': longitude,
      'DateTime': DateTime.now()
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['Id'] as String,
      name: data['Name'] as String,
      phoneNumber: data['PhoneNumber'] as String,
      street: data['Street'] as String,
      city: data['City'] as String,
      country: data['Country'] as String,
      details: data['Details'] as String,
      postalCode: data['PostalCode'] as String,
      latitude: data['Latitude'] ?? 0.0,
      longitude: data['Longitude'] ?? 0.0,
      selectedAddress: data['SelectedAddress'] as bool,
      dateTime: (data['DateTime'] as Timestamp).toDate(),
    );
  }

  factory AddressModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AddressModel(
      id: snapshot.id,
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      country: data['Country'] ?? '',
      details: data['Details'] ?? '',
      postalCode: data['PostalCode'] ?? '',
      latitude: data['Latitude'] ?? 0.0,
      longitude: data['Longitude'] ?? 0.0,
      selectedAddress: data['SelectedAddress'] as bool,
      dateTime: (data['DateTime'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return '$country, $city, $street, $postalCode, $details';
  }
}
