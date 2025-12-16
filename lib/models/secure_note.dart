import 'package:uuid/uuid.dart';

class SecureNote {
  final String id;
  final String title;
  final String content;
  final String category; // Wi-Fi, Crypto, Personal, Tax, Other
  final DateTime createdAt;
  final DateTime updatedAt;

  SecureNote({
    String? id,
    required this.title,
    required this.content,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  SecureNote copyWith({
    String? title,
    String? content,
    String? category,
    DateTime? updatedAt,
  }) {
    return SecureNote(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SecureNote.fromJson(Map<String, dynamic> json) {
    return SecureNote(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  bool matchesQuery(String query) {
    if (query.trim().isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        content.toLowerCase().contains(lowerQuery) ||
        category.toLowerCase().contains(lowerQuery);
  }
}
