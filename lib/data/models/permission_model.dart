class PermissionModel {
  final String id;
  final String phoneNumber;
  final String email;
  final String name;
  final String role;
  final bool isAuthorized;
  final String country; // رمز الدولة (SA, AE, SY, etc.)
  final DateTime createdAt;
  final DateTime? updatedAt;

  PermissionModel({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.name,
    required this.role,
    required this.isAuthorized,
    required this.country,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert from Map
  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'manager',
      isAuthorized: map['isAuthorized'] ?? false,
      country: map['country'] ?? 'SA', // افتراضي السعودية
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'name': name,
      'role': role,
      'isAuthorized': isAuthorized,
      'country': country,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method
  PermissionModel copyWith({
    String? newId,
    String? newPhoneNumber,
    String? newEmail,
    String? newName,
    String? newRole,
    bool? newIsAuthorized,
    String? newCountry,
    DateTime? newCreatedAt,
    DateTime? newUpdatedAt,
  }) {
    return PermissionModel(
      id: newId ?? id,
      phoneNumber: newPhoneNumber ?? phoneNumber,
      email: newEmail ?? email,
      name: newName ?? name,
      role: newRole ?? role,
      isAuthorized: newIsAuthorized ?? isAuthorized,
      country: newCountry ?? country,
      createdAt: newCreatedAt ?? createdAt,
      updatedAt: newUpdatedAt ?? updatedAt,
    );
  }
}
