import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'theme/app_theme.dart';

class MemoryTimelinePage extends StatefulWidget {
  const MemoryTimelinePage({super.key});

  @override
  State<MemoryTimelinePage> createState() => _MemoryTimelinePageState();
}

class _MemoryTimelinePageState extends State<MemoryTimelinePage> {
  String? _selectedCategoryId;

  void abrirNovaMemoria() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CriarMemoriaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final memories = _selectedCategoryId == null
        ? state.memories
        : state.filterByCategory(_selectedCategoryId);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 390),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'MemoryBox',
                                  style: GoogleFonts.cormorantGaramond(
                                    color: const Color(0xffa44a62),
                                    fontSize: 31,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffd7c7cb)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://i.pravatar.cc/100',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person_outline,
                                        color: Color(0xff7b7468),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // TAGS
                            SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _categoriaChip('Todos', null),
                                  ...state.categories.map(
                                    (c) => _categoriaChipModel(c),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            // TITLE
                            Text(
                              'Timeline',
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xff342f2b),
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${memories.length} memória${memories.length != 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: AppTheme.textMedium,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // MEMORY CARDS
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final memory = memories[i];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 390),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            child: _MemoriaCard(memory: memory),
                          ),
                        ),
                      );
                    },
                    childCount: memories.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            // FAB
            Positioned(
              right: 18,
              bottom: 16,
              child: GestureDetector(
                onTap: abrirNovaMemoria,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xffc86b86), Color(0xffe78ca1)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffc86b86).withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoriaChip(String texto, String? id) {
    final ativo = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryId = id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: ativo ? const Color(0xffa44a62) : const Color(0xffece8d5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            texto,
            style: TextStyle(
              color: ativo ? Colors.white : const Color(0xff807a6e),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoriaChipModel(CategoryModel c) {
    final ativo = _selectedCategoryId == c.id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryId = ativo ? null : c.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: ativo ? c.color : c.color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(c.icon, size: 13, color: const Color(0xff2f2b27)),
              const SizedBox(width: 5),
              Text(
                c.name,
                style: TextStyle(
                  color: const Color(0xff2f2b27),
                  fontSize: 12,
                  fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── MEMORY CARD ────────────────────────────────────────────────────────────

class _MemoriaCard extends StatelessWidget {
  final MemoryModel memory;
  const _MemoriaCard({required this.memory});

  @override
  Widget build(BuildContext context) {
    final date = memory.date;
    final monthNames = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ'
    ];
    final dataStr =
        '${date.day.toString().padLeft(2, '0')} ${monthNames[date.month - 1]}\n${date.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xfff1eedc),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOPO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (memory.categories.isNotEmpty)
                      Text(
                        memory.categories
                            .map((c) => c.name.toUpperCase())
                            .join(' · '),
                        style: const TextStyle(
                          color: Color(0xffba7b81),
                          fontSize: 9,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      memory.title,
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xff2f2b27),
                        fontSize: 26,
                        height: 0.95,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dataStr,
                      style: const TextStyle(
                        color: Color(0xffa39d92),
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.more_vert, color: Color(0xff9f8f92), size: 17),
                  SizedBox(width: 4),
                  Icon(Icons.bookmark_border,
                      color: Color(0xff9f8f92), size: 17),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            memory.description,
            style: const TextStyle(
              color: Color(0xff6e695f),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (memory.categories.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: memory.categories
                  .map((c) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.color.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(c.icon,
                                size: 11, color: const Color(0xff3f3b34)),
                            const SizedBox(width: 4),
                            Text(c.name,
                                style: const TextStyle(
                                    fontSize: 11, color: Color(0xff3f3b34))),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── CRIAR MEMÓRIA ──────────────────────────────────────────────────────────

class CriarMemoriaPage extends StatefulWidget {
  const CriarMemoriaPage({super.key});

  @override
  State<CriarMemoriaPage> createState() => _CriarMemoriaPageState();
}

class _CriarMemoriaPageState extends State<CriarMemoriaPage> {
  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Set<String> _selectedCategoryIds = {};

  @override
  void dispose() {
    _tituloController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_tituloController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um título para a memória')),
      );
      return;
    }
    final state = context.read<AppState>();
    final categorias = state.categories
        .where((c) => _selectedCategoryIds.contains(c.id))
        .toList();
    state.addMemory(MemoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _tituloController.text.trim(),
      description: _descController.text.trim(),
      date: _selectedDate,
      categories: categorias,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final months = [
      '',
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez'
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close,
                            size: 20, color: Color(0xff4e4a45)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'MemoryBox',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null)
                          setState(() => _selectedDate = picked);
                      },
                      child: Text(
                        '${_selectedDate.day.toString().padLeft(2, '0')} / ${months[_selectedDate.month]} / ${_selectedDate.year}',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _label('TÍTULO DA MEMÓRIA:'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tituloController,
                    maxLines: 2,
                    style: GoogleFonts.cormorantGaramond(
                      color: const Color(0xff2f2b27),
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'O que aconteceu que vale a pena lembrar?',
                      hintStyle: GoogleFonts.cormorantGaramond(
                        color: const Color(0xffc4bbaf),
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label('DESCRIÇÃO:'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    style:
                        const TextStyle(color: Color(0xff6e695f), fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descreva este momento especial...',
                      hintStyle:
                          TextStyle(color: Color(0xffc4bbaf), fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _label('CATEGORIAS'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: state.categories.map((c) {
                      final sel = _selectedCategoryIds.contains(c.id);
                      return GestureDetector(
                        onTap: () => setState(() {
                          sel
                              ? _selectedCategoryIds.remove(c.id)
                              : _selectedCategoryIds.add(c.id);
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? c.color : c.color.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: sel ? c.color : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(c.icon,
                                  size: 14, color: const Color(0xff3f3b34)),
                              const SizedBox(width: 6),
                              Text(
                                c.name,
                                style: TextStyle(
                                  color: const Color(0xff3f3b34),
                                  fontSize: 13,
                                  fontWeight:
                                      sel ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  // BUTTON
                  GestureDetector(
                    onTap: _salvar,
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xffa74860), Color(0xffef8ea6)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Criar Memória',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String texto) => Text(
        texto,
        style: const TextStyle(
          color: Color(0xff6f6a61),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
      );
}
