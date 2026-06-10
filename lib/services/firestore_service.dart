import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/category_model.dart';

/// CRUD completo no Firestore.
/// Todos os documentos incluem os campos obrigatórios:
///   • criado_por    — e-mail de quem criou
///   • usuario_logado — e-mail do usuário atual (amarração dinâmica)
class FirestoreService {
  static final FirestoreService _i = FirestoreService._();
  factory FirestoreService() => _i;
  FirestoreService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // E-mail dinâmico — NUNCA string estática
  String get _email => _auth.currentUser?.email ?? '';

  CollectionReference get _col => _db.collection('memorias');

  // ── CREATE ────────────────────────────────────────────────────────────────
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
      // ✅ Amarração dinâmica obrigatória — captura o e-mail autenticado
      'criado_por': _email,
      'usuario_logado': _email,
    });
  }

  // ── READ (stream em tempo real) ───────────────────────────────────────────
  Stream<List<MemoryModel>> streamMemorias() {
    return _col
        .where('usuario_logado', isEqualTo: _email)
        .orderBy('data', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  // ── UPDATE ────────────────────────────────────────────────────────────────
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
      'usuario_logado': _email, // atualiza com o e-mail atual
    });
  }

  // ── DELETE ────────────────────────────────────────────────────────────────
  Future<void> deletarMemoria(String id) => _col.doc(id).delete();

  // ── Mapper ───────────────────────────────────────────────────────────────
  MemoryModel _fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MemoryModel(
      id: doc.id,
      title: d['titulo'] ?? '',
      description: d['descricao'] ?? '',
      date: (d['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
      categories: const [],     // categorias visuais gerenciadas pelo AppState local
      criadoPor: d['criado_por'] ?? '',
      usuarioLogado: d['usuario_logado'] ?? '',
    );
  }
}
