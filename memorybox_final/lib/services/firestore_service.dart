import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../services/auth_service.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ── Referências por usuário ─────────────────────────────────────────────
  // Cada usuário tem sua própria sub-coleção isolada:
  // users/{email}/categories/{id}
  // users/{email}/memories/{id}

  static String get _userEmail => AuthService.currentEmail;

  static CollectionReference<Map<String, dynamic>> get _categoriesRef =>
      _db.collection('users').doc(_userEmail).collection('categories');

  static CollectionReference<Map<String, dynamic>> get _memoriesRef =>
      _db.collection('users').doc(_userEmail).collection('memories');

  // ══════════════════════════════════════════════════════════
  //  CATEGORIES — Streams em tempo real
  // ══════════════════════════════════════════════════════════

  static Stream<List<CategoryModel>> categoriesStream() {
    return _categoriesRef
        .orderBy('atualizado_em', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => CategoryModel.fromFirestore(d)).toList());
  }

  static Future<void> addCategory(CategoryModel cat) async {
    await _categoriesRef.doc(cat.id).set(cat.toFirestore());
  }

  static Future<void> updateCategory(CategoryModel cat) async {
    await _categoriesRef.doc(cat.id).update(cat.toFirestore());
  }

  static Future<void> deleteCategory(String id) async {
    await _categoriesRef.doc(id).delete();
    // Remove referência das memórias
    final mems = await _memoriesRef
        .where('category_ids', arrayContains: id)
        .get();
    final batch = _db.batch();
    for (final doc in mems.docs) {
      final ids = List<String>.from(doc['category_ids']);
      ids.remove(id);
      batch.update(doc.reference, {'category_ids': ids});
    }
    await batch.commit();
  }

  // ══════════════════════════════════════════════════════════
  //  MEMORIES — Streams em tempo real
  // ══════════════════════════════════════════════════════════

  static Stream<List<MemoryModel>> memoriesStream(
      List<CategoryModel> allCategories) {
    return _memoriesRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MemoryModel.fromFirestore(d, allCategories))
            .toList());
  }

  static Future<void> addMemory(MemoryModel memory) async {
    await _memoriesRef.doc(memory.id).set(memory.toFirestore());
  }

  static Future<void> updateMemory(MemoryModel memory) async {
    await _memoriesRef.doc(memory.id).update({
      'title': memory.title,
      'description': memory.description,
      'date': Timestamp.fromDate(memory.date),
      'category_ids': memory.categories.map((c) => c.id).toList(),
      'usuario_logado': AuthService.currentEmail,
    });
  }

  static Future<void> deleteMemory(String id) async {
    await _memoriesRef.doc(id).delete();
  }
}
