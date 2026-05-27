import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_state.dart';
import 'models/category_model.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
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
    final state = context.read<AppState>();
    final selectedCats = state.categories
        .where((c) => _selectedCategoryIds.contains(c.id))
        .toList();
    state.addMemory(MemoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: _descController.text.trim(),
      date: _selectedDate,
      categories: selectedCats,
    ));
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffa44a62),
              onPrimary: Colors.white,
              surface: Color(0xfffbf8df),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xfff7f4f7),
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
                        child: const Icon(
                          Icons.close,
                          size: 22,
                          color: Color(0xff4e4a45),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'MemoryBox',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xffa44a62),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // DATA
                          Center(
                            child: Text(
                              'HOJE',
                              style: TextStyle(
                                color: const Color(0xff8d887e),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: GestureDetector(
                              onTap: _pickDate,
                              child: Text(
                                '${_selectedDate.day.toString().padLeft(2, '0')} / '
                                '${_selectedDate.month.toString().padLeft(2, '0')} / '
                                '${_selectedDate.year}',
                                style: GoogleFonts.cormorantGaramond(
                                  color: const Color(0xffa44a62),
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          // FOTO
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xffece8d5),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 35,
                                      color: Color(0xff726d62),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Adicionar uma foto',
                                      style: TextStyle(
                                        color: Color(0xff726d62),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // TÍTULO
                          _label('TÍTULO DA MEMÓRIA:'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _titleController,
                            maxLines: 2,
                            style: GoogleFonts.cormorantGaramond(
                              color: const Color(0xff2f2b27),
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'O que aconteceu que vale a pena lembrar?',
                              hintStyle: GoogleFonts.cormorantGaramond(
                                color: const Color(0xffc4bbaf),
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // DESCRIÇÃO
                          _label('DESCRIÇÃO:'),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffece8d5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _descController,
                              maxLines: 4,
                              style: const TextStyle(
                                color: Color(0xff4e4a45),
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Conte mais sobre esse momento...',
                                hintStyle: TextStyle(
                                  color: Color(0xffa8a294),
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // CATEGORIAS
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _label('CATEGORIAS'),
                              const Text(
                                '+ Nova Tag',
                                style: TextStyle(
                                  color: Color(0xffd37a8f),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: state.categories.map((cat) {
                              final ativo =
                                  _selectedCategoryIds.contains(cat.id);
                              return GestureDetector(
                                onTap: () => setState(() {
                                  if (ativo) {
                                    _selectedCategoryIds.remove(cat.id);
                                  } else {
                                    _selectedCategoryIds.add(cat.id);
                                  }
                                }),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: ativo
                                        ? cat.color
                                        : const Color(0xffece8d5),
                                    borderRadius:
                                        BorderRadius.circular(30),
                                    border: ativo
                                        ? Border.all(
                                            color: cat.color
                                                .withOpacity(0.8),
                                            width: 1.5)
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(cat.icon,
                                          size: 13,
                                          color: ativo
                                              ? const Color(0xff4a4540)
                                              : const Color(0xff756f64)),
                                      const SizedBox(width: 6),
                                      Text(
                                        cat.name,
                                        style: TextStyle(
                                          color: ativo
                                              ? const Color(0xff4a4540)
                                              : const Color(0xff756f64),
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

                          const SizedBox(height: 22),

                          // DATA PICKER VISUAL
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xfff0edd8),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Color(0xffd8d8bc),
                                    child: Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color(0xff615d55),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'DATA',
                                        style: TextStyle(
                                          color: Color(0xff8d887e),
                                          fontSize: 10,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_selectedDate.day.toString().padLeft(2, '0')}/'
                                        '${_selectedDate.month.toString().padLeft(2, '0')}/'
                                        '${_selectedDate.year}',
                                        style: const TextStyle(
                                          color: Color(0xff4f4b45),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right,
                                      color: Color(0xffa8a294), size: 20),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // BOTÃO SALVAR
                          GestureDetector(
                            onTap: _save,
                            child: Container(
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffa74860),
                                    Color(0xffef8ea6),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
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
                          const SizedBox(height: 20),
                        ],
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

  Widget _label(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Color(0xff6f6a61),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 3,
      ),
    );
  }
}
