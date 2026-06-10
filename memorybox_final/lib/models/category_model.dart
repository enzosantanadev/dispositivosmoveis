import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Mapa de ícones (IconData não serializa direto no Firestore) ───────────
const Map<String, IconData> kIconMap = {
  'favorite': Icons.favorite,
  'restaurant': Icons.restaurant,
  'flight_takeoff': Icons.flight_takeoff,
  'park': Icons.park,
  'celebration': Icons.celebration,
  'work_outline': Icons.work_outline,
  'person_outline': Icons.person_outline,
  'school_outlined': Icons.school_outlined,
  'sports_soccer': Icons.sports_soccer,
  'music_note': Icons.music_note,
  'camera_alt_outlined': Icons.camera_alt_outlined,
  'star_outline': Icons.star_outline,
  'home_outlined': Icons.home_outlined,
  'pets': Icons.pets,
  'beach_access': Icons.beach_access,
  'directions_car_outlined': Icons.directions_car_outlined,
  'local_hospital_outlined': Icons.local_hospital_outlined,
  'book_outlined': Icons.book_outlined,
};

String iconKey(IconData icon) {
  return kIconMap.entries
      .firstWhere((e) => e.value == icon,
          orElse: () => const MapEntry('favorite', Icons.favorite))
      .key;
}

// ─── CategoryModel ──────────────────────────────────────────────────────────
class CategoryModel {
  final String id;
  String name;
  Color color;
  IconData icon;
  final String criadoPor; // e-mail do usuário Firebase

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.criadoPor,
  });

  // Firestore → Model
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: d['name'] ?? '',
      color: Color(d['color'] ?? 0xFFE8A0A0),
      icon: kIconMap[d['icon']] ?? Icons.favorite,
      criadoPor: d['criado_por'] ?? '',
    );
  }

  // Model → Firestore
  Map<String, dynamic> toFirestore() => {
        'name': name,
        'color': color.value,
        'icon': iconKey(icon),
        'criado_por': criadoPor,
        'atualizado_em': FieldValue.serverTimestamp(),
      };
}

// ─── MemoryModel ─────────────────────────────────────────────────────────────
class MemoryModel {
  final String id;
  String title;
  String description;
  DateTime date;
  String? imagePath;
  List<CategoryModel> categories;
  final String criadoPor; // e-mail do usuário Firebase

  MemoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
    required this.categories,
    required this.criadoPor,
  });

  // Firestore → Model (categories precisam ser resolvidas depois)
  factory MemoryModel.fromFirestore(
      DocumentSnapshot doc, List<CategoryModel> allCategories) {
    final d = doc.data() as Map<String, dynamic>;

    // IDs das categorias guardados como lista de strings
    final List<String> catIds =
        List<String>.from(d['category_ids'] ?? []);
    final cats =
        allCategories.where((c) => catIds.contains(c.id)).toList();

    DateTime parsedDate;
    final rawDate = d['date'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else {
      parsedDate = DateTime.tryParse(rawDate?.toString() ?? '') ??
          DateTime.now();
    }

    return MemoryModel(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      date: parsedDate,
      imagePath: d['image_path'],
      categories: cats,
      criadoPor: d['criado_por'] ?? '',
    );
  }

  // Model → Firestore
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'image_path': imagePath,
        'category_ids': categories.map((c) => c.id).toList(),
        'criado_por': criadoPor,
        'criado_em': FieldValue.serverTimestamp(),
      };
}
