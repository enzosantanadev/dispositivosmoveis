import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'create_memory_screen.dart';

class MemoryTimelinePage extends StatefulWidget {
  const MemoryTimelinePage({super.key});

  @override
  State<MemoryTimelinePage> createState() => _MemoryTimelinePageState();
}

class _MemoryTimelinePageState extends State<MemoryTimelinePage> {
  String? _selectedCategoryId;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    List<MemoryModel> memories;
    if (_searchQuery.isNotEmpty) {
      memories = state.searchMemories(_searchQuery);
    } else {
      memories = state.filterByCategory(_selectedCategoryId);
    }

    return Scaffold(
      backgroundColor: const Color(0xfff7f4f7),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
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
                                  color: const Color(0xffd7c7cb),
                                ),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Color(0xffa44a62),
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // SEARCH
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xffece8d5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) =>
                                setState(() => _searchQuery = v),
                            style: const TextStyle(
                              color: Color(0xff615d56),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xffa8a294),
                                size: 22,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xffa8a294),
                                        size: 18,
                                      ),
                                    )
                                  : null,
                              hintText: 'Pesquise suas memórias...',
                              hintStyle: const TextStyle(
                                color: Color(0xffa8a294),
                                fontSize: 13,
                              ),
                              contentPadding:
                                  const EdgeInsets.only(top: 15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TAGS / CATEGORIAS
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

                        const SizedBox(height: 18),

                        // MEMORIES LIST
                        if (memories.isEmpty)
                          _buildEmpty()
                        else
                          ...memories.map((m) => _MemoryCard(memory: m)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // FAB
            Positioned(
              right: 18,
              bottom: 20,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateMemoryScreen(),
                  ),
                ),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffc86b86),
                        Color(0xffe78ca1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffc86b86).withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
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
            color:
                ativo ? const Color(0xffa44a62) : const Color(0xffece8d5),
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

  Widget _categoriaChipModel(CategoryModel cat) {
    final ativo = _selectedCategoryId == cat.id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedCategoryId = ativo ? null : cat.id;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: ativo ? cat.color : cat.color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
            border: ativo
                ? Border.all(color: cat.color, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(cat.icon,
                  size: 12, color: const Color(0xff4a4540)),
              const SizedBox(width: 5),
              Text(
                cat.name,
                style: const TextStyle(
                  color: Color(0xff4a4540),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.photo_album_outlined,
                size: 52, color: const Color(0xffba8a97)),
            const SizedBox(height: 16),
            Text(
              'Nenhuma memória ainda',
              style: GoogleFonts.cormorantGaramond(
                color: const Color(0xff6b5560),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toque no + para criar sua primeira memória',
              style: TextStyle(
                color: Color(0xffb8a8b0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── CARD DE MEMÓRIA ───────────────────────────────────────
class _MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  const _MemoryCard({required this.memory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xfff1eedc),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topo do card
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
                        memory.categories.first.name.toUpperCase(),
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
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${memory.date.day.toString().padLeft(2, '0')} / '
                      '${memory.date.month.toString().padLeft(2, '0')} / '
                      '${memory.date.year}',
                      style: const TextStyle(
                        color: Color(0xffa39d92),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.more_vert,
                      color: Color(0xff9f8f92), size: 17),
                  SizedBox(width: 4),
                  Icon(Icons.bookmark_border,
                      color: Color(0xff9f8f92), size: 17),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Descrição
          Text(
            memory.description,
            style: const TextStyle(
              color: Color(0xff6e695f),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          // Tags chips
          if (memory.categories.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: memory.categories.map((c) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.icon, size: 10, color: const Color(0xff4a4540)),
                      const SizedBox(width: 4),
                      Text(
                        c.name,
                        style: const TextStyle(
                          color: Color(0xff4a4540),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
