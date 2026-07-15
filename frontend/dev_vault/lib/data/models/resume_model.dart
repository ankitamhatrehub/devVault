class ResumeModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileSize;
  final String publicId;
  final DateTime uploadedAt;

  ResumeModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.publicId,
    required this.uploadedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['_id'] as String? ?? json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSize: json['fileSize'] as String,
      publicId: json['publicId'] as String,
      uploadedAt: DateTime.parse(json['createdAt'] as String? ?? json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'publicId': publicId,
    };
  }
}
