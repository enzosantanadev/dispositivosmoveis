import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'theme/app_theme.dart';
import 'services/firestore_service.dart';

// ─── TIMELINE ────────────────────────────────────────────────────────────────
class MemoryTimelinePage extends StatefulWidget {
  const MemoryTimelinePage({super.key});
  @override
  State<MemoryTimelinePage> createState() => _MemoryTimelinePageState();
}

class _MemoryTimelinePageState extends State<MemoryTimelinePage> {
  String? _selectedCategoryId;
  final _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(clipBehavior: Clip.none, children: [
          // ── Stream Firestore em tempo real ────────────────────────────
          StreamBuilder<List<MemoryModel>>(
            stream: _fs.streamMemorias(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary));
              }
              if (snap.hasError) {
                return Center(child: Text('Erro: ${snap.error}'));
              }

              final todasMemorias = snap.data ?? [];
              // Filtra por categoria se selecionado
              final memories = _selectedCategoryId == null
                  ? todasMemorias
                  : state.filterByCategory(todasMemorias, _selectedCategoryId);

              return CustomScrollView(
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
                              // HEADER com avatar real do Firebase
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('MemoryBox',
                                      style: GoogleFonts.cormorantGaramond(
                                        color: const Color(0xffa44a62),
                                        fontSize: 31,
                                        fontWeight: FontWeight.w700)),
                                  _avatarUsuario(),
                                ]),
                              const SizedBox(height: 20),
                              // FILTROS DE CATEGORIA
                              SizedBox(
                                height: 36,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _chip('Todos', null),
                                    ...state.categories.map(_chipCategoria),
                                  ])),
                              const SizedBox(height: 28),
                              Text('Timeline',
                                  style: GoogleFonts.cormorantGaramond(
                                    color: const Color(0xff342f2b),
                                    fontSize: 44, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(
                                '${memories.length} memória${memories.length != 1 ? "s" : ""}',
                                style: const TextStyle(
                                    color: AppTheme.textMedium, fontSize: 13)),
                              const SizedBox(height: 18),
                            ]))))),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 390),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            child: _MemoriaCard(
                              memory: memories[i],
                              onEditar: () => _abrirEditar(memories[i]),
                              onDeletar: () => _confirmarDeletar(memories[i]))))),
                      childCount: memories.length)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ]);
            }),
          // FAB
          Positioned(
            right: 18, bottom: 16,
            child: GestureDetector(
              onTap: _abrirCriar,
              child: Container(
                width: 58, height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xffc86b86), Color(0xffe78ca1)]),
                  boxShadow: [BoxShadow(
                    color: const Color(0xffc86b86).withValues(alpha: 0.28),
                    blurRadius: 18, offset: const Offset(0, 8))]),
                child: const Icon(Icons.add, color: Colors.white, size: 30)))),
        ])));
  }

  Widget _avatarUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffd7c7cb))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: user?.photoURL != null
            ? Image.network(user!.photoURL!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person_outline, color: Color(0xff7b7468)))
            : const Icon(Icons.person_outline, color: Color(0xff7b7468))));
  }

  Widget _chip(String txt, String? id) {
    final ativo = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryId = id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: ativo ? const Color(0xffa44a62) : const Color(0xffece8d5),
            borderRadius: BorderRadius.circular(30)),
          child: Text(txt,
              style: TextStyle(
                color: ativo ? Colors.white : const Color(0xff807a6e),
                fontSize: 12, fontWeight: FontWeight.w500)))));
  }

  Widget _chipCategoria(CategoryModel c) {
    final ativo = _selectedCategoryId == c.id;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () =>
            setState(() => _selectedCategoryId = ativo ? null : c.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: ativo ? c.color : c.color.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(30)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(c.icon, size: 13, color: const Color(0xff2f2b27)),
            const SizedBox(width: 5),
            Text(c.name,
                style: TextStyle(
                  color: const Color(0xff2f2b27), fontSize: 12,
                  fontWeight: ativo ? FontWeight.w700 : FontWeight.w500)),
          ]))));
  }

  void _abrirCriar() => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CriarEditarMemoriaPage()));

  void _abrirEditar(MemoryModel m) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CriarEditarMemoriaPage(memoria: m)));

  Future<void> _confirmarDeletar(MemoryModel m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Apagar memória?',
            style: TextStyle(color: AppTheme.textDark)),
        content: Text('«${m.title}» será removida permanentemente.',
            style: const TextStyle(color: AppTheme.textMedium)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppTheme.textMedium))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Apagar',
                style: TextStyle(color: Colors.red.shade400))),
        ]));
    if (ok == true) await FirestoreService().deletarMemoria(m.id);
  }
}

// ─── CARD ─────────────────────────────────────────────────────────────────────
class _MemoriaCard extends StatelessWidget {
  final MemoryModel memory;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;
  const _MemoriaCard(
      {required this.memory,
      required this.onEditar,
      required this.onDeletar});

  @override
  Widget build(BuildContext context) {
    final date = memory.date;
    const meses = [
      'JAN','FEV','MAR','ABR','MAI','JUN',
      'JUL','AGO','SET','OUT','NOV','DEZ'
    ];
    final dataStr =
        '${date.day.toString().padLeft(2, '0')} ${meses[date.month - 1]}\n${date.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xfff1eedc),
        borderRadius: BorderRadius.circular(28)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      memory.categories.map((c) => c.name.toUpperCase()).join(' · '),
                      style: const TextStyle(
                        color: Color(0xffba7b81), fontSize: 9,
                        letterSpacing: 1.4, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(memory.title,
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xff2f2b27), fontSize: 26,
                        height: 0.95, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(dataStr,
                      style: const TextStyle(
                        color: Color(0xffa39d92), fontSize: 10, height: 1.2)),
                ])),
            // ── Menu de ações ────────────────────────────────────────────
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: Color(0xff9f8f92), size: 17),
              color: const Color(0xfffbf8df),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'editar') onEditar();
                if (v == 'deletar') onDeletar();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'editar',
                    child: Row(children: [
                      Icon(Icons.edit_outlined,
                          size: 16, color: AppTheme.textDark),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ])),
                PopupMenuItem(value: 'deletar',
                    child: Row(children: [
                      Icon(Icons.delete_outline,
                          size: 16, color: Colors.red.shade400),
                      const SizedBox(width: 8),
                      Text('Apagar',
                          style: TextStyle(color: Colors.red.shade400)),
                    ])),
              ]),
          ]),
        const SizedBox(height: 15),
        Text(memory.description,
            style: const TextStyle(
              color: Color(0xff6e695f), fontSize: 14, height: 1.5)),
        if (memory.categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: memory.categories.map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c.color.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(c.icon, size: 11, color: const Color(0xff3f3b34)),
                const SizedBox(width: 4),
                Text(c.name,
                    style: const TextStyle(
                      fontSize: 11, color: Color(0xff3f3b34))),
              ]))).toList()),
        ],
        // ✅ Mostra criado_por para transparência
        const SizedBox(height: 10),
        Text('por ${memory.criadoPor}',
            style: const TextStyle(
              color: Color(0xffb8a9a0), fontSize: 10, fontStyle: FontStyle.italic)),
      ]));
  }
}

// ─── CRIAR / EDITAR MEMÓRIA ───────────────────────────────────────────────────
class CriarEditarMemoriaPage extends StatefulWidget {
  final MemoryModel? memoria; // null = criar, não-null = editar
  const CriarEditarMemoriaPage({super.key, this.memoria});
  @override
  State<CriarEditarMemoriaPage> createState() =>
      _CriarEditarMemoriaPageState();
}

class _CriarEditarMemoriaPageState extends State<CriarEditarMemoriaPage> {
  final _fs = FirestoreService();
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _data = DateTime.now();
  final Set<String> _catIds = {};
  bool _salvando = false;

  bool get _editando => widget.memoria != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      _tituloCtrl.text = widget.memoria!.title;
      _descCtrl.text = widget.memoria!.description;
      _data = widget.memoria!.date;
      _catIds.addAll(widget.memoria!.categories.map((c) => c.id));
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_tituloCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Digite um título para a memória')));
      return;
    }
    setState(() => _salvando = true);
    final state = context.read<AppState>();
    final cats = state.categories
        .where((c) => _catIds.contains(c.id))
        .toList();
    try {
      if (_editando) {
        await _fs.atualizarMemoria(
          id: widget.memoria!.id,
          titulo: _tituloCtrl.text.trim(),
          descricao: _descCtrl.text.trim(),
          data: _data,
          categorias: cats);
      } else {
        await _fs.criarMemoria(
          titulo: _tituloCtrl.text.trim(),
          descricao: _descCtrl.text.trim(),
          data: _data,
          categorias: cats);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    const meses = [
      '','jan','fev','mar','abr','mai','jun',
      'jul','ago','set','out','nov','dez'
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
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close,
                          size: 20, color: Color(0xff4e4a45))),
                    const SizedBox(width: 12),
                    Text('MemoryBox',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 31, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 24),
                  // DATA
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final p = await showDatePicker(
                          context: context,
                          initialDate: _data,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                        if (p != null) setState(() => _data = p);
                      },
                      child: Text(
                        '${_data.day.toString().padLeft(2, '0')} / ${meses[_data.month]} / ${_data.year}',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 36, fontWeight: FontWeight.w700)))),
                  const SizedBox(height: 22),
                  _label('TÍTULO DA MEMÓRIA:'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tituloCtrl,
                    maxLines: 2,
                    style: GoogleFonts.cormorantGaramond(
                      color: const Color(0xff2f2b27),
                      fontSize: 28, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'O que aconteceu que vale a pena lembrar?',
                      hintStyle: GoogleFonts.cormorantGaramond(
                        color: const Color(0xffc4bbaf),
                        fontSize: 26, fontWeight: FontWeight.w400))),
                  const SizedBox(height: 16),
                  _label('DESCRIÇÃO:'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    style: const TextStyle(
                        color: Color(0xff6e695f), fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Descreva este momento especial...',
                      hintStyle: TextStyle(
                          color: Color(0xffc4bbaf), fontSize: 14))),
                  const SizedBox(height: 20),
                  _label('CATEGORIAS'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10, runSpacing: 10,
                    children: state.categories.map((c) {
                      final sel = _catIds.contains(c.id);
                      return GestureDetector(
                        onTap: () => setState(() =>
                            sel ? _catIds.remove(c.id) : _catIds.add(c.id)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? c.color : c.color.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: sel ? c.color : Colors.transparent,
                              width: 2)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(c.icon, size: 14,
                                color: const Color(0xff3f3b34)),
                            const SizedBox(width: 6),
                            Text(c.name,
                                style: TextStyle(
                                  color: const Color(0xff3f3b34), fontSize: 13,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.w500)),
                          ])));
                    }).toList()),
                  const Spacer(),
                  // BOTÃO SALVAR
                  GestureDetector(
                    onTap: _salvando ? null : _salvar,
                    child: Container(
                      width: double.infinity, height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xffa74860), Color(0xffef8ea6)])),
                      child: Center(
                        child: _salvando
                            ? const SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                            : Text(
                                _editando ? 'Salvar Alterações' : 'Criar Memória',
                                style: const TextStyle(
                                  color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.w700))))),
                ]))))));
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
        color: Color(0xff6f6a61), fontSize: 10,
        fontWeight: FontWeight.w700, letterSpacing: 3));
}
