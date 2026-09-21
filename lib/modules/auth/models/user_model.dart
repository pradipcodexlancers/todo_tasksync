/// User Data Model
///
/// Represents an authenticated user in the system.
/// Includes JSON serialization and deserialization helpers.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  /// Factory constructor to parse JSON into [UserModel]
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  /// Convert [UserModel] instance into a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'profile_image_url': profileImageUrl,
    };
  }

  /// Helper to copy the model with modified properties
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
