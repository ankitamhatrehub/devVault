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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : null,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
