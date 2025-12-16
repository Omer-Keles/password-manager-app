import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class PasswordEntry {
  PasswordEntry({
    String? id,
    required this.label,
    required this.username,
    required this.password,
    required this.createdAt,
    this.category = 'Genel',
  }) : id = id ?? _uuid.v4();

  final String id;
  final String label;
  final String username;
  final String password;
  final DateTime createdAt;
  final String category;

  PasswordEntry copyWith({
    String? id,
    String? label,
    String? username,
    String? password,
    DateTime? createdAt,
    String? category,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      label: label ?? this.label,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final lower = query.toLowerCase();
    return label.toLowerCase().contains(lower) ||
        username.toLowerCase().contains(lower);
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'] as String?,
      label: json['label'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: json['category'] as String? ?? 'Genel',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'username': username,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }
}
