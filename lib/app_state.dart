import 'package:flutter/material.dart';
import 'models/category_model.dart';

/// Estado local do app.
/// Categorias: gerenciadas localmente (podem ser migradas para Firestore futuramente).
/// Memórias: agora vêm do Firestore via FirestoreService — AppState não as armazena mais.
class AppState extends ChangeNotifier {
  List<CategoryModel> _categories = [
    CategoryModel(id: '1', name: 'Família',   color: const Color(0xFFE8A0A0), icon: Icons.favorite),
    CategoryModel(id: '2', name: 'Comida',    color: const Color(0xFFB5D5A0), icon: Icons.restaurant),
    CategoryModel(id: '3', name: 'Viagem',    color: const Color(0xFFA0C4E8), icon: Icons.flight_takeoff),
    CategoryModel(id: '4', name: 'Natureza',  color: const Color(0xFFD4B8E0), icon: Icons.park),
    CategoryModel(id: '5', name: 'Festa',     color: const Color(0xFFF0D080), icon: Icons.celebration),
  ];

  List<CategoryModel> get categories => _categories;

  // ── Categorias ──────────────────────────────────────────────────────────
  void addCategory(CategoryModel cat) {
    _categories.add(cat);
    notifyListeners();
  }

  void updateCategory(String id, String name, Color color, IconData icon) {
    final idx = _categories.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _categories[idx].name = name;
      _categories[idx].color = color;
      _categories[idx].icon = icon;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ── Helpers para filtro/busca sobre lista externa ────────────────────────
  List<MemoryModel> filterByCategory(
      List<MemoryModel> memories, String? categoryId) {
    if (categoryId == null) return memories;
    return memories
        .where((m) => m.categories.any((c) => c.id == categoryId))
        .toList();
  }

  List<MemoryModel> searchMemories(List<MemoryModel> memories, String query) {
    if (query.isEmpty) return memories;
    final q = query.toLowerCase();
    return memories.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.categories.any((c) => c.name.toLowerCase().contains(q));
    }).toList();
  }
}
