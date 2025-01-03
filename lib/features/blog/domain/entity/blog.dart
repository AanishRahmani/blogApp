// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

class Blog {
  final String id;
  final String? posterName;
  final String posterid;
  final String title;
  final String content;
  final String imageUrl;

  final List<String> topics;
  final DateTime updatedAt;

  Blog({
    required this.id,
    this.posterName,
    required this.posterid,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
  });
}
