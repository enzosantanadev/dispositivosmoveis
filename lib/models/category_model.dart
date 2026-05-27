import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  String name;
  Color color;
  IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

class MemoryModel {
  final String id;
  String title;
  String description;
  DateTime date;
  String? imagePath;
  List<CategoryModel> categories;

  MemoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
    required this.categories,
  });
}
