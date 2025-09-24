import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:brother_admin_panel/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? id;
  String? phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel(
      {this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.id,
      this.role = AppRole.user,
      this.profilePicture = '',
      this.createdAt,
      this.updatedAt});

  String get fullName => '$firstName $lastName';
  String get formattedDate => TFormatter.formateDate(createdAt);

  String get formattedUpdatedDate => TFormatter.formateDate(updatedAt);

  //String get formattedPhoneNo => TFormatter.for;
  static UserModel empty() => UserModel(
      id: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      profilePicture: '',
      email: '');

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name.toLowerCase(),
      'Email': email,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture: data.containsKey('ProfilePicture')
            ? data['ProfilePicture'] ?? ''
            : '',
        role: data.containsKey('Role')
            ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString()
                ? AppRole.admin
                : AppRole.user
            : AppRole.user,
        createdAt: data.containsKey('CreatedAt')
            ? data['CreatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt')
            ? data['UpdatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
      );
    }
    return UserModel.empty();
  }
}
