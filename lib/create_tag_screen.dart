import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'theme/app_theme.dart';

class CreateTagScreen extends StatefulWidget {
  final CategoryModel? editCategory;

  const CreateTagScreen({super.key, this.editCategory});

  @override
  State<CreateTagScreen> createState() => _CreateTagScreenState(
}

class _CreateTagScreenState extends State<CreateTagScreen> {
  final _nameController = TextEditingController();
  late Color _selectedColor;
  late IconData _selectedIcon;

  final List<Color> _colorOptions = [
    const Color(0xFFE8A0A0),
    const Color(0xFFB5D5A0),
    const Color(0xFFA0C4E8),
    const Color(0xFFD4B8E0),
    const Color(0xFFF0D080),
    const Color(0xFFE0C4A0),
    const Color(0xFFA0D4C8),
    const Color(0xFFF4B8D0),
    const Color(0xFFB8D4F0),
    const Color(0xFFD0E8A0),
    const Color(0xFFF0C8A0),
    const Color(0xFFC8B8F0),
  ];

  final List<IconData> _iconOptions = [
    Icons.favorite,
    Icons.restaurant,
    Icons.flight_takeoff,
    Icons.park,
    Icons.celebration,
    Icons.work_outline,
    Icons.person_outline,
    Icons.school_outlined,
    Icons.sports_soccer,
    Icons.music_note,
    Icons.camera_alt_outlined,
    Icons.star_outline,
    Icons.home_outlined,
    Icons.pets,
    Icons.beach_access,
    Icons.directions_car_outlined,
    Icons.local_hospital_outlined,
    Icons.book_outlined,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editCategory != null) {
      _nameController.text = widget.editCategory!.name;
      _selectedColor = widget.editCategory!.color;
      _selectedIcon = widget.editCategory!.icon;
    } else {
      _selectedColor = _colorOptions[0];
      _selectedIcon = _iconOptions[0];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.editCategory != null;

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um nome para a tag'),
          backgroundColor: AppTheme.primary,
        ),
      );
      return;
    }
    final state = context.read<AppState>();
    if (_isEditing) {
      state.updateCategory(
          widget.editCategory!.id, name, _selectedColor, _selectedIcon);
    } else {
      state.addCategory(CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        color: _selectedColor,
        icon: _selectedIcon,
      ));
    }
    if (widget.editCategory != null) {
      Navigator.pop(context);
    } else {
      _nameController.clear();
      setState(() {
        _selectedColor = _colorOptions[0];
        _selectedIcon = _iconOptions[0];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tag criada com sucesso!'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isModal = widget.editCategory != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppTheme.divider, width: 0.5)),
              ),
              child: Row(
                children: [
                  if (isModal) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: AppTheme.primary, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      isModal ? 'Editar Tag' : 'Nova Tag',
                      textAlign: isModal ? TextAlign.center : TextAlign.left,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  if (isModal) const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BADGE DATA
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        () {
                          final now = DateTime.now();
                          return 'HOJE   ${now.day.toString().padLeft(2, '0')} / ${now.month.toString().padLeft(2, '0')} / ${now.year}';
                        }(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMedium,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PRÉVIA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'PRÉVIA DA TAG',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.textLight,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedColor.withOpacity(0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_selectedIcon,
                                    size: 16,
                                    color: AppTheme.textDark
                                        .withOpacity(0.7)),
                                const SizedBox(width: 8),
                                Text(
                                  _nameController.text.isEmpty
                                      ? 'Nome da tag'
                                      : _nameController.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textDark.withOpacity(
                                        _nameController.text.isEmpty
                                            ? 0.4
                                            : 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // NOME DA TAG
                    _label('NOME DA TAG'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ex: Família, Viagem, Trabalho...',
                      ),
                    ),

                    const SizedBox(height: 28),

                    // COR
                    _label('COR DA TAG'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _colorOptions.map((color) {
                        final sel = _selectedColor == color;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedColor = color),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sel
                                    ? AppTheme.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: sel
                                  ? [
                                      BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 8)
                                    ]
                                  : [],
                            ),
                            child: sel
                                ? const Icon(Icons.check,
                                    size: 16, color: AppTheme.textDark)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // ÍCONE
                    _label('ÍCONE DA TAG'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _iconOptions.map((icon) {
                        final sel = _selectedIcon == icon;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedIcon = icon),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel
                                  ? _selectedColor
                                  : AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: sel
                                    ? _selectedColor
                                    : AppTheme.divider,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              icon,
                              size: 20,
                              color: sel
                                  ? AppTheme.textDark.withOpacity(0.8)
                                  : AppTheme.textMedium,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 36),

                    // BOTÃO
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _nameController.text.trim().isEmpty
                                ? null
                                : _save,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: AppTheme.divider,
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'Salvar Alterações' : 'Criar Tag',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
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
    );
  }

  Widget _label(String texto) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.textMedium,
          ),
        ),
      ],
    );
  }
}
