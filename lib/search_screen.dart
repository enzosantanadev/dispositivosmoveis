import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'theme/app_theme.dart';
import 'services/firestore_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  String? _selectedCategoryId;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: StreamBuilder<List<MemoryModel>>(
            stream: FirestoreService().streamMemorias(),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
              }
              final todas = snap.data ?? [];
              var results = state.searchMemories(todas, _query);
              if (_selectedCategoryId != null) {
                results = state.filterByCategory(results, _selectedCategoryId);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 16),
                  _buildCategoryFilter(state.categories),
                  const SizedBox(height: 16),
                  if (_query.isNotEmpty || _selectedCategoryId != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text('${results.length} resultado${results.length != 1 ? "s" : ""}',
                          style: const TextStyle(
                            fontSize: 12, color: AppTheme.textLight,
                            fontWeight: FontWeight.w500, letterSpacing: 0.5))),
                  Expanded(
                    child: _query.isEmpty && _selectedCategoryId == null
                        ? _buildEmptyState()
                        : results.isEmpty
                            ? _buildNoResults()
                            : _buildResults(results)),
                ]));
            })),
      ]));
  }

  Widget _buildHeader() => Container(
    color: AppTheme.primary,
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('MemoryBox',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: Colors.white, letterSpacing: 0.5)),
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.person_outline,
                  color: Colors.white, size: 20)),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Pesquise suas memÃ³rias...',
                hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                prefixIcon: Icon(Icons.search,
                    color: Colors.white.withValues(alpha: 0.7)),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () { _ctrl.clear(); setState(() => _query = ''); },
                        child: Icon(Icons.close,
                            color: Colors.white.withValues(alpha: 0.7), size: 18))
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                filled: false))),
        ]))));

  Widget _buildCategoryFilter(List<CategoryModel> cats) => SizedBox(
    height: 36,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        GestureDetector(
          onTap: () => setState(() => _selectedCategoryId = null),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _selectedCategoryId == null
                  ? AppTheme.primary : AppTheme.surface,
              borderRadius: BorderRadius.circular(20)),
            child: Text('Todas',
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: _selectedCategoryId == null
                      ? Colors.white : AppTheme.textMedium)))),
        ...cats.map((c) {
          final sel = _selectedCategoryId == c.id;
          return GestureDetector(
            onTap: () =>
                setState(() => _selectedCategoryId = sel ? null : c.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? c.color : c.color.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? c.color : Colors.transparent, width: 1.5)),
              child: Row(children: [
                Icon(c.icon, size: 12,
                    color: AppTheme.textDark.withValues(alpha: 0.7)),
                const SizedBox(width: 5),
                Text(c.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      color: AppTheme.textDark.withValues(alpha: 0.85))),
              ])));
        }),
      ]));

  Widget _buildEmptyState() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
        child: const Icon(Icons.search, size: 32, color: AppTheme.primary)),
      const SizedBox(height: 16),
      const Text('Busque suas memÃ³rias',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
              color: AppTheme.textDark)),
      const SizedBox(height: 8),
      const Text('Digite um tÃ­tulo, descriÃ§Ã£o\nou selecione uma categoria',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppTheme.textLight)),
    ]));

  Widget _buildNoResults() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.inbox_outlined, size: 40, color: AppTheme.textLight),
      const SizedBox(height: 12),
      Text('Nenhuma memÃ³ria encontrada\npara "$_query"',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppTheme.textLight)),
    ]));

  Widget _buildResults(List<MemoryModel> results) =>
      ListView.separated(
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) =>
            _SearchResultCard(memory: results[i], query: _query));
}

class _SearchResultCard extends StatelessWidget {
  final MemoryModel memory;
  final String query;
  const _SearchResultCard({required this.memory, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(memory.date.day.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppTheme.primary, height: 1)),
            Text(_mes(memory.date.month),
                style: const TextStyle(
                  fontSize: 10, color: AppTheme.textMedium,
                  fontWeight: FontWeight.w500)),
          ])),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _highlight(memory.title, query),
            const SizedBox(height: 4),
            Text(memory.description,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textMedium)),
            if (memory.categories.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: memory.categories.map((c) =>
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.color.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10)),
                  child: Text(c.name,
                      style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: AppTheme.textDark)))).toList()),
            ],
          ])),
      ]));
  }

  Widget _highlight(String text, String query) {
    if (query.isEmpty) {
      return Text(text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
              color: AppTheme.textDark));
    }
    final lo = text.toLowerCase();
    final lq = query.toLowerCase();
    final idx = lo.indexOf(lq);
    if (idx == -1) {
      return Text(text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
              color: AppTheme.textDark));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
            color: AppTheme.textDark),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(text: text.substring(idx, idx + query.length),
              style: TextStyle(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                color: AppTheme.primary)),
          TextSpan(text: text.substring(idx + query.length)),
        ]));
  }

  static const _meses = [
    'jan','fev','mar','abr','mai','jun',
    'jul','ago','set','out','nov','dez'
  ];
  String _mes(int m) => _meses[m - 1];
}

