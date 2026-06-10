import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'models/memory_model.dart';
import 'theme/app_theme.dart';
import 'create_tag_screen.dart';
import 'services/firestore_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildCategoryWrap(state.categories),
            const SizedBox(height: 24),
            if (_selectedCategoryId != null)
              Expanded(child: _buildFilteredMemories(state)),
          ]))));
  }

  Widget _buildHeader(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('CATEGORIAS',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
              letterSpacing: 2.5, color: AppTheme.textMedium)),
      GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreateTagScreen())),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.3), width: 1)),
          child: const Row(children: [
            Icon(Icons.add, size: 14, color: AppTheme.primary),
            SizedBox(width: 4),
            Text('Nova Tag',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppTheme.primary)),
          ]))),
    ]);

  Widget _buildCategoryWrap(List<CategoryModel> cats) => Wrap(
    spacing: 10, runSpacing: 10,
    children: cats.map((cat) {
      final sel = _selectedCategoryId == cat.id;
      return GestureDetector(
        onTap: () =>
            setState(() => _selectedCategoryId = sel ? null : cat.id),
        onLongPress: () => _showOptions(cat),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: sel ? cat.color : cat.color.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: sel ? cat.color.withValues(alpha: 0.8) : Colors.transparent,
              width: 2),
            boxShadow: sel
                ? [BoxShadow(
                    color: cat.color.withValues(alpha: 0.4),
                    blurRadius: 8, offset: const Offset(0, 3))]
                : []),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(cat.icon, size: 15,
                color: AppTheme.textDark.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Text(cat.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                  color: AppTheme.textDark.withValues(alpha: 0.85))),
          ])));
    }).toList());

  Widget _buildFilteredMemories(AppState state) {
    final cat = state.categories.firstWhere((c) => c.id == _selectedCategoryId);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 4, height: 16,
            decoration: BoxDecoration(
                color: cat.color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
      ]),
      const SizedBox(height: 12),
      Expanded(
        child: StreamBuilder<List<MemoryModel>>(
          stream: FirestoreService().streamMemorias(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                  color: AppTheme.primary));
            }
            final todas = snap.data ?? [];
            final filtradas = state.filterByCategory(todas, _selectedCategoryId);
            if (filtradas.isEmpty) {
              return Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(cat.icon, size: 40, color: cat.color),
                  const SizedBox(height: 12),
                  Text('Nenhuma memÃ³ria em\n${cat.name} ainda',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppTheme.textLight, fontSize: 14)),
                ]));
            }
            return ListView.separated(
              itemCount: filtradas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  _MemoryCard(memory: filtradas[i], accentColor: cat.color));
          })),
    ]);
  }

  void _showOptions(CategoryModel cat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.3), shape: BoxShape.circle),
              child: Icon(cat.icon, color: cat.color, size: 18)),
            const SizedBox(width: 12),
            Text(cat.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600,
                    color: AppTheme.textDark)),
          ]),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.edit_outlined, color: AppTheme.textDark),
            title: const Text('Editar categoria',
                style: TextStyle(
                    color: AppTheme.textDark, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => CreateTagScreen(editCategory: cat)));
            }),
          const Divider(color: AppTheme.divider),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
            title: Text('Excluir categoria',
                style: TextStyle(
                    color: Colors.red.shade400, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(cat);
            }),
        ])));
  }

  void _confirmDelete(CategoryModel cat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir categoria?',
            style: TextStyle(color: AppTheme.textDark)),
        content: Text(
            'A categoria "${cat.name}" serÃ¡ removida.',
            style: const TextStyle(color: AppTheme.textMedium)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: AppTheme.textMedium))),
          TextButton(
            onPressed: () {
              context.read<AppState>().deleteCategory(cat.id);
              if (_selectedCategoryId == cat.id) {
                setState(() => _selectedCategoryId = null);
              }
              Navigator.pop(context);
            },
            child: Text('Excluir',
                style: TextStyle(color: Colors.red.shade400))),
        ]));
  }
}

class _MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  final Color accentColor;
  const _MemoryCard({required this.memory, required this.accentColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.cardBg,
      borderRadius: BorderRadius.circular(14),
      border: Border(left: BorderSide(color: accentColor, width: 4)),
      boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 6, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(memory.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
              color: AppTheme.textDark)),
      const SizedBox(height: 4),
      Text(memory.description,
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: AppTheme.textMedium)),
      const SizedBox(height: 8),
      Text(
        '${memory.date.day.toString().padLeft(2, '0')}/'
        '${memory.date.month.toString().padLeft(2, '0')}/'
        '${memory.date.year}',
        style: const TextStyle(fontSize: 11, color: AppTheme.textLight,
            fontWeight: FontWeight.w500)),
    ]));
}

