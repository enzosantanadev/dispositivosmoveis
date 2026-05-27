import 'package:flutter/material.dart';
import 'models/category_model.dart';

class AppState extends ChangeNotifier {
  List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'Família',
      color: const Color(0xFFE8A0A0),
      icon: Icons.favorite,
    ),
    CategoryModel(
      id: '2',
      name: 'Comida',
      color: const Color(0xFFB5D5A0),
      icon: Icons.restaurant,
    ),
    CategoryModel(
      id: '3',
      name: 'Viagem',
      color: const Color(0xFFA0C4E8),
      icon: Icons.flight_takeoff,
    ),
    CategoryModel(
      id: '4',
      name: 'Natureza',
      color: const Color(0xFFD4B8E0),
      icon: Icons.park,
    ),
    CategoryModel(
      id: '5',
      name: 'Festa',
      color: const Color(0xFFF0D080),
      icon: Icons.celebration,
    ),
  ];

  List<MemoryModel> _memories = [
    MemoryModel(
      id: '1',
      title: 'Viagem para o nordeste',
      description: 'Uma viagem incrível com a família para o nordeste brasileiro.',
      date: DateTime(2026, 4, 25),
      categories: [],
    ),
    MemoryModel(
      id: '2',
      title: 'Jantar especial',
      description: 'Aquele jantar que vai ficar na memória para sempre.',
      date: DateTime(2026, 3, 10),
      categories: [],
    ),
    MemoryModel(
      id: '3',
      title: 'Aniversário da mamãe',
      description: 'Festa surpresa com toda a família reunida.',
      date: DateTime(2026, 2, 14),
      categories: [],
    ),
  ];

  List<CategoryModel> get categories => _categories;

  List<MemoryModel> get memories {
    final sorted = List<MemoryModel>.from(_memories);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }  

  // ── Categorias ──────────────────────────────────────
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
    for (var m in _memories) {
      m.categories.removeWhere((c) => c.id == id);
    }
    notifyListeners();
  }

  // ── Memórias ────────────────────────────────────────
  void addMemory(MemoryModel memory) {
    _memories.insert(0, memory);
    notifyListeners();
  }



  List<MemoryModel> filterByCategory(String? categoryId) {
    if (categoryId == null) return memories; // já ordenado
    return memories
        .where((m) => m.categories.any((c) => c.id == categoryId))
        .toList();
  }

  List<MemoryModel> searchMemories(String query) {
    if (query.isEmpty) return memories;
    final q = query.toLowerCase();
    final results = memories.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.categories.any((c) => c.name.toLowerCase().contains(q));
    }).toList();
    return results;
  }

}