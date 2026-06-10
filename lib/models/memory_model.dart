import 'category_model.dart';

class MemoryModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final List<CategoryModel> categories;
  final String criadoPor;
  final String usuarioLogado;

  MemoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.categories,
    required this.criadoPor,
    required this.usuarioLogado,
  });
}