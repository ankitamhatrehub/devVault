class ChatMessageModel {
  final String id;
  final String message;
  final bool isUser;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.message,
    required this.isUser,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
