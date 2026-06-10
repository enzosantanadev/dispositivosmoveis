import 'dart:async';
import 'package:flutter/material.dart';
import 'models/category_model.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

class AppState extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<MemoryModel> _memories = [];
  bool _loading = true;
  String? _error;

  StreamSubscription? _catSub;
  StreamSubscription? _memSub;

  List<CategoryModel> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;

  // Memórias ordenadas por data da memória (decrescente)
  List<MemoryModel> get memories {
    final sorted = List<MemoryModel>.from(_memories);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // Inicia os streams do Firestore (chamar após login)
  void startListening() {
    _loading = true;
    _error = null;
    notifyListeners();

    // 1. Ouvir categorias primeiro
    _catSub = FirestoreService.categoriesStream().listen(
      (cats) {
        _categories = cats;
        // 2. Reinicar stream de memórias sempre que categorias mudarem
        _memSub?.cancel();
        _memSub = FirestoreService.memoriesStream(_categories).listen(
          (mems) {
            _memories = mems;
            _loading = false;
            _error = null;
            notifyListeners();
          },
          onError: (e) {
            _error = 'Erro ao carregar memórias: $e';
            _loading = false;
            notifyListeners();
          },
        );
        notifyListeners();
      },
      onError: (e) {
        _error = 'Erro ao carregar categorias: $e';
        _loading = false;
        notifyListeners();
      },
    );
  }

  // Para os streams (chamar no logout)
  void stopListening() {
    _catSub?.cancel();
    _memSub?.cancel();
    _catSub = null;
    _memSub = null;
    _categories = [];
    _memories = [];
    _loading = true;
    _error = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  // ── CATEGORIES ──────────────────────────────────────────────────────────

  Future<void> addCategory(CategoryModel cat) async {
    await FirestoreService.addCategory(cat);
    // Stream atualiza automaticamente
  }

  Future<void> updateCategory(
      String id, String name, Color color, IconData icon) async {
    final cat = _categories.firstWhere((c) => c.id == id);
    cat.name = name;
    cat.color = color;
    cat.icon = icon;
    await FirestoreService.updateCategory(cat);
  }

  Future<void> deleteCategory(String id) async {
    await FirestoreService.deleteCategory(id);
  }

  // ── MEMORIES ────────────────────────────────────────────────────────────

  Future<void> addMemory(MemoryModel memory) async {
    await FirestoreService.addMemory(memory);
  }

  Future<void> updateMemory(MemoryModel memory) async {
    await FirestoreService.updateMemory(memory);
  }

  Future<void> deleteMemory(String id) async {
    await FirestoreService.deleteMemory(id);
  }

  // ── BUSCA / FILTRO (local, sobre dados já carregados) ───────────────────

  List<MemoryModel> searchMemories(String query) {
    if (query.isEmpty) return memories;
    final q = query.toLowerCase();
    return memories.where((m) {
      return m.title.toLowerCase().contains(q) ||
          m.description.toLowerCase().contains(q) ||
          m.categories.any((c) => c.name.toLowerCase().contains(q));
    }).toList();
  }

  List<MemoryModel> filterByCategory(String? categoryId) {
    if (categoryId == null) return memories;
    return memories
        .where((m) => m.categories.any((c) => c.id == categoryId))
        .toList();
  }

  // Helper: e-mail do usuário atual
  String get userEmail => AuthService.currentEmail;
}
