// import 'dart:convert';

import 'package:blogapp/features/blog/domain/entity/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterid,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterid,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterid: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String? ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at'] as String),
    );
  }

  BlogModel copyWith({
    String? id,
    String? posterid,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterid: posterid ?? this.posterid,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  // String toJson() => json.encode(toMap());

  // factory BlogModel.fromJson(String source) =>
  //     BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
