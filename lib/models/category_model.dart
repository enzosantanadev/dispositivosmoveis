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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Sem nome',
      color: Color(map['colorValue'] ?? 0xFF808080),
      // O ícone não é salvo no Firestore, então usamos um padrão.
      // A lógica de exibição pode buscar o ícone correto no AppState se necessário.
      icon: Icons.label,
    );
  }
}
