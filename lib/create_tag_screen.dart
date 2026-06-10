import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'models/category_model.dart';
import 'theme/app_theme.dart';

class CreateTagScreen extends StatefulWidget {
  final CategoryModel? editCategory;

  const CreateTagScreen({super.key, this.editCategory});

  @override
  State<CreateTagScreen> createState() => _CreateTagScreenState();
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

  final List<Map<String, dynamic>> _iconOptions = [
    {'icon': Icons.favorite, 'label': 'Família'},
    {'icon': Icons.restaurant, 'label': 'Comida'},
    {'icon': Icons.flight_takeoff, 'label': 'Viagem'},
    {'icon': Icons.park, 'label': 'Natureza'},
    {'icon': Icons.celebration, 'label': 'Festa'},
    {'icon': Icons.work_outline, 'label': 'Trabalho'},
    {'icon': Icons.person_outline, 'label': 'Pessoal'},
    {'icon': Icons.school_outlined, 'label': 'Estudo'},
    {'icon': Icons.sports_soccer, 'label': 'Esporte'}, 
    {'icon': Icons.music_note, 'label': 'Música'},
    {'icon': Icons.camera_alt_outlined, 'label': 'Foto'},
    {'icon': Icons.star_outline, 'label': 'Especial'},
    {'icon': Icons.home_outlined, 'label': 'Casa'},
    {'icon': Icons.pets, 'label': 'Pets'},
    {'icon': Icons.beach_access, 'label': 'Praia'},
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
      _selectedIcon = Icons.favorite;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.editCategory != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateBadge(),
                    const SizedBox(height: 20),
                    _buildPreviewCard(),
                    const SizedBox(height: 24),
                    _buildNameField(),
                    const SizedBox(height: 24),
                    _buildExistingTags(),
                    const SizedBox(height: 24),
                    _buildColorPicker(),
                    const SizedBox(height: 24),
                    _buildIconPicker(),
                    const SizedBox(height: 32),
                    _buildSaveButton(context),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.divider, width: 0.5)),
      ),
      child: Row(
        children: [
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
          const Expanded(
            child: Text(
              'MemoryBox',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildDateBadge() {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'HOJE   ${now.day.toString().padLeft(2, '0')} / ${now.month.toString().padLeft(2, '0')} / ${now.year}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textMedium,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          const Text(
            'Prévia da Tag',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textLight,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    size: 16, color: AppTheme.textDark.withOpacity(0.7)),
                const SizedBox(width: 8),
                Text(
                  _nameController.text.isEmpty
                      ? 'Nome da tag'
                      : _nameController.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark.withOpacity(_nameController.text.isEmpty ? 0.4 : 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NOME DA TAG',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.textMedium,
          ),
        ),
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
            hintText: 'Dê um nome para a nova tag...',
            hintMaxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildExistingTags() {
    final state = context.read<AppState>();
    final existingTags = _isEditing
        ? state.categories.where((c) => c.id != widget.editCategory!.id).toList()
        : state.categories;

    if (existingTags.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TAGS EXISTENTES:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.textMedium,
          ),
        ),
        const SizedBox(height: 12),
        ...existingTags.map((cat) => _ExistingTagRow(
              category: cat,
              onEdit: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateTagScreen(editCategory: cat),
                ),
              ),
              onDelete: () {
                context.read<AppState>().deleteCategory(cat.id);
                setState(() {});
              },
            )),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.palette_outlined, size: 14, color: AppTheme.textMedium),
            SizedBox(width: 6),
            Text(
              'NOVA TAG',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppTheme.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _colorOptions.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                          )
                        ]
                      : [],
                ),
                child: isSelected
                    ? const Icon(Icons.check,
                        size: 16, color: AppTheme.textDark)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIconPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.emoji_emotions_outlined,
                size: 14, color: AppTheme.textMedium),
            SizedBox(width: 6),
            Text(
              'ÍCONE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppTheme.textMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _iconOptions.map((item) {
            final icon = item['icon'] as IconData;
            final isSelected = _selectedIcon == icon;
            return GestureDetector(
              onTap: () => setState(() => _selectedIcon = icon),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _selectedColor
                        : AppTheme.divider,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? AppTheme.textDark.withOpacity(0.8)
                      : AppTheme.textMedium,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nameController.text.trim().isEmpty ? null : _save,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppTheme.divider,
        ),
        child: Text(_isEditing ? 'Salvar Alterações' : 'Criar Tag'),
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final state = context.read<AppState>();

    if (_isEditing) {
      state.updateCategory(
        widget.editCategory!.id,
        name,
        _selectedColor,
        _selectedIcon,
      );
    } else {
      state.addCategory(CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        color: _selectedColor,
        icon: _selectedIcon,
      ));
    }

    Navigator.pop(context);
  }
}

class _ExistingTagRow extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExistingTagRow({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child:
                Icon(category.icon, size: 14, color: AppTheme.textDark),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.edit_outlined,
                  size: 16, color: AppTheme.textMedium),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.delete_outline,
                  size: 16, color: Colors.red.shade300),
            ),
          ),
        ],
      ),
    );
  }
}
