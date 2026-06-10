import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category_model.dart';
import '../models/memory_model.dart';

/// CRUD completo no Firestore.
/// ColeÃ§Ãµes: memorias, tags
class FirestoreService {
  static final FirestoreService _i = FirestoreService._();
  factory FirestoreService() => _i;
  FirestoreService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _email => _auth.currentUser?.email ?? '';

  CollectionReference get _col  => _db.collection('memorias');
  CollectionReference get _tags => _db.collection('tags');

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // TAGS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<void> criarTag(CategoryModel cat) {
    return _tags.doc(cat.id).set({
      'id': cat.id,
      'name': cat.name,
      'colorValue': cat.color.value,
      'iconCodePoint': cat.icon.codePoint,
      'iconFontFamily': cat.icon.fontFamily ?? 'MaterialIcons',
      'usuario_logado': _email,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<CategoryModel>> streamTags() {
    return _tags
        .where('usuario_logado', isEqualTo: _email)
        .snapshots()
        .map((snap) => snap.docs.map(_tagFromDoc).toList());
  }

  Future<void> atualizarTag(CategoryModel cat) {
    return _tags.doc(cat.id).update({
      'name': cat.name,
      'colorValue': cat.color.value,
      'iconCodePoint': cat.icon.codePoint,
      'iconFontFamily': cat.icon.fontFamily ?? 'MaterialIcons',
      'usuario_logado': _email,
    });
  }

  Future<void> deletarTag(String id) => _tags.doc(id).delete();

  CategoryModel _tagFromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: d['name'] ?? '',
      color: Color(d['colorValue'] ?? 0xFFE8A0A0),
      icon: IconData(
        d['iconCodePoint'] ?? Icons.label.codePoint,
        fontFamily: d['iconFontFamily'] ?? 'MaterialIcons',
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // MEMÃ“RIAS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  Future<void> criarMemoria({
    required String titulo,
    required String descricao,
    required DateTime data,
    required List<CategoryModel> categorias,
  }) {
    return _col.add({
      'titulo': titulo,
      'descricao': descricao,
      'data': Timestamp.fromDate(data),
      'categorias': categorias
          .map((c) => {'id': c.id, 'name': c.name, 'colorValue': c.color.value})
          .toList(),
      'criado_em': FieldValue.serverTimestamp(),
      'atualizado_em': FieldValue.serverTimestamp(),
      'criado_por': _email,
      'usuario_logado': _email,
    });
  }

  Stream<List<MemoryModel>> streamMemorias() {
    return _col
        .where('usuario_logado', isEqualTo: _email)
        .orderBy('data', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Future<void> atualizarMemoria({
    required String id,
    required String titulo,
    required String descricao,
    required DateTime data,
    required List<CategoryModel> categorias,
  }) {
    return _col.doc(id).update({
      'titulo': titulo,
      'descricao': descricao,
      'data': Timestamp.fromDate(data),
      'categorias': categorias
          .map((c) => {'id': c.id, 'name': c.name, 'colorValue': c.color.value})
          .toList(),
      'atualizado_em': FieldValue.serverTimestamp(),
      'usuario_logado': _email,
    });
  }

  Future<void> deletarMemoria(String id) => _col.doc(id).delete();

  MemoryModel _fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MemoryModel(
      id: doc.id,
      title: d['titulo'] ?? '',
      description: d['descricao'] ?? '',
      date: (d['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
      categories: (d['categorias'] as List<dynamic>? ?? [])
          .map((c) => CategoryModel.fromMap(c))
          .toList(),
      criadoPor: d['criado_por'] ?? '',
      usuarioLogado: d['usuario_logado'] ?? '',
    );
  }
}

