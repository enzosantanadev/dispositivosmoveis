import 'package:flutter/material.dart';
import 'models/category_model.dart';
import 'models/memory_model.dart';
import 'services/firestore_service.dart';

/// Estado global do app.
/// Tags agora são persistidas no Firestore em tempo real.
class AppState extends ChangeNotifier {
  final _fs = FirestoreService();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  // Chama isso após login (em MainShell.initState)
  void iniciarStreamTags() {
    _fs.streamTags().listen((tags) {
      _categories = tags;
      notifyListeners();
    });
  }

  // ── Tags ──────────────────────────────────────────────────────────────────
  Future<void> addCategory(CategoryModel cat) async {
    await _fs.criarTag(cat);
  }

  Future<void> updateCategory(String id, String name, Color color, IconData icon) async {
    await _fs.atualizarTag(CategoryModel(id: id, name: name, color: color, icon: icon));
  }

  Future<void> deleteCategory(String id) async {
    await _fs.deletarTag(id);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  List<MemoryModel> filterByCategory(List<MemoryModel> memories, String? categoryId) {
    if (categoryId == null) return memories;
    return memories.where((m) => m.categories.any((c) => c.id == categoryId)).toList();
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
