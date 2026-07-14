class ProfileModel {
  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.bio,
    required this.designation,
    required this.experience,
    required this.currentCompany,
    required this.location,
    required this.avatar,
    required this.avatarPublicId, // Add this line
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String bio;
  final String designation;
  final String experience;
  final String currentCompany;
  final String location;
  final String avatar;
  final String avatarPublicId; // Add this line
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Safely look inside the nested 'avatar' map from your MongoDB document
    final avatarData = json['avatar'] as Map<String, dynamic>?;

    return ProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      currentCompany: json['currentComapny']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      // Extract url from the avatar object, fall back to empty string
      avatar: avatarData?['url']?.toString() ?? '',
      // Extract publicId from the avatar object, fall back to empty string
      avatarPublicId: avatarData?['publicId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'bio': bio,
      'designation': designation,
      'experience': experience,
      'currentComapny': currentCompany,
      'location': location,
      // Package it back into the exact object format your backend wants
      'avatar': {'url': avatar, 'publicId': avatarPublicId},
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
