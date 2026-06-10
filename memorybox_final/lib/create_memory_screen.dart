import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'services/auth_service.dart';

class CreateMemoryScreen extends StatefulWidget {
  const CreateMemoryScreen({super.key});

  @override
  State<CreateMemoryScreen> createState() => _CreateMemoryScreenState();
}

class _CreateMemoryScreenState extends State<CreateMemoryScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Set<String> _selectedCategoryIds = {};
  bool _salvando = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um título para a memória'),
          backgroundColor: Color(0xffa44a62),
        ),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final state = context.read<AppState>();
      final selectedCats = state.categories
          .where((c) => _selectedCategoryIds.contains(c.id))
          .toList();

      await state.addMemory(MemoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: _descController.text.trim(),
        date: _selectedDate,
        categories: selectedCats,
        criadoPor: AuthService.currentEmail, // ← amarração Firebase
      ));

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xffa44a62),
            onPrimary: Colors.white,
            surface: Color(0xfffbf8df),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    // Exibe o e-mail do usuário logado
    final userEmail = AuthService.currentEmail;

    return Scaffold(
      backgroundColor: const Color(0xfff7f4f7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close,
                            size: 22, color: Color(0xff4e4a45)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nova Memória',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge usuário logado (amarração dinâmica)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xffa44a62).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_pin_outlined,
                                  size: 13,
                                  color: Color(0xffa44a62)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Criado por: $userEmail',
                                  style: const TextStyle(
                                    color: Color(0xffa44a62),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // DATA
                        GestureDetector(
                          onTap: _pickDate,
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  'DATA DA MEMÓRIA',
                                  style: TextStyle(
                                    color: Color(0xff8d887e),
                                    fontSize: 10,
                                    letterSpacing: 2.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_selectedDate.day.toString().padLeft(2, '0')} / '
                                  '${_selectedDate.month.toString().padLeft(2, '0')} / '
                                  '${_selectedDate.year}',
                                  style: GoogleFonts.cormorantGaramond(
                                    color: const Color(0xffa44a62),
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Foto placeholder
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xffece8d5),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    size: 32,
                                    color: Color(0xff726d62)),
                                SizedBox(height: 8),
                                Text(
                                  'Adicionar foto',
                                  style: TextStyle(
                                      color: Color(0xff726d62),
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // TÍTULO
                        _label('TÍTULO DA MEMÓRIA'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _titleController,
                          maxLines: 2,
                          style: GoogleFonts.cormorantGaramond(
                            color: const Color(0xff2f2b27),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'O que aconteceu?',
                            hintStyle: GoogleFonts.cormorantGaramond(
                              color: const Color(0xffc4bbaf),
                              fontSize: 24,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // DESCRIÇÃO
                        _label('DESCRIÇÃO'),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffece8d5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _descController,
                            maxLines: 4,
                            style: const TextStyle(
                                color: Color(0xff4e4a45), fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'Conte mais sobre esse momento...',
                              hintStyle: TextStyle(
                                  color: Color(0xffa8a294), fontSize: 14),
                              contentPadding: EdgeInsets.all(14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // CATEGORIAS
                        _label('CATEGORIAS'),
                        const SizedBox(height: 12),
                        state.loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xffa44a62)))
                            : Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    state.categories.map((cat) {
                                  final ativo = _selectedCategoryIds
                                      .contains(cat.id);
                                  return GestureDetector(
                                    onTap: () => setState(() {
                                      if (ativo) {
                                        _selectedCategoryIds
                                            .remove(cat.id);
                                      } else {
                                        _selectedCategoryIds.add(cat.id);
                                      }
                                    }),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 150),
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10),
                                      decoration: BoxDecoration(
                                        color: ativo
                                            ? cat.color
                                            : const Color(0xffece8d5),
                                        borderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(cat.icon,
                                              size: 13,
                                              color: const Color(
                                                  0xff4a4540)),
                                          const SizedBox(width: 6),
                                          Text(
                                            cat.name,
                                            style: const TextStyle(
                                              color: Color(0xff4a4540),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                        const SizedBox(height: 30),

                        // BOTÃO SALVAR
                        GestureDetector(
                          onTap: _salvando ? null : _save,
                          child: Container(
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: _salvando
                                  ? null
                                  : const LinearGradient(colors: [
                                      Color(0xffa74860),
                                      Color(0xffef8ea6),
                                    ]),
                              color: _salvando
                                  ? const Color(0xffcccccc)
                                  : null,
                            ),
                            child: Center(
                              child: _salvando
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Criar Memória',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
