import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MemoryBoxApp());
}

class MemoryBoxApp extends StatelessWidget {
  const MemoryBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff7f4f7),
      ),
      home: const MemoryTimelinePage(),
    );
  }
}

class MemoryTimelinePage extends StatefulWidget {
  const MemoryTimelinePage({super.key});

  @override
  State<MemoryTimelinePage> createState() => _MemoryTimelinePageState();
}

class _MemoryTimelinePageState extends State<MemoryTimelinePage> {
  void abrirNovaMemoria() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CriarMemoriaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
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
                        /// HEADER
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  'https://i.pravatar.cc/100',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// SEARCH
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xffece8d5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
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

                        /// TAGS
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              categoria('Todos', true),
                              categoria('Família'),
                              categoria('Comida'),
                              categoria('Viagem'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// TITLE
                        Text(
                          'Timeline',
                          style: GoogleFonts.cormorantGaramond(
                            color: const Color(0xff342f2b),
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// CARD 1
                        memoriaGrande(),

                        const SizedBox(height: 22),

                        /// CARD 2
                        memoriaDupla(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// FLOAT BUTTON
            Positioned(
              left: 18,
              bottom: 86,
              child: GestureDetector(
                onTap: abrirNovaMemoria,
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
                        color: const Color(0xffc86b86)
                            .withValues(alpha: 0.28),
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

      /// BOTTOM BAR
      bottomNavigationBar: bottomBar(0),
    );
  }

  Widget categoria(String texto, [bool ativo = false]) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color:
              ativo ? const Color(0xffa44a62) : const Color(0xffece8d5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color:
                ativo ? Colors.white : const Color(0xff807a6e),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget memoriaGrande() {
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
          topoCard(
            categoria: 'VIAGEM',
            titulo: 'Manhã na Costa',
            data: '24 OUT\n2023',
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
              height: 255,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'O ar estava fresco e cheirava a sal. Observamos o sol romper a névoa da manhã, pintando tudo em tons de dourado pálido e lavanda. Um momento de pura quietude.',
            style: TextStyle(
              color: Color(0xff6e695f),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget memoriaDupla() {
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
          topoCard(
            categoria: 'CONQUISTAS',
            titulo: 'Primeira Horta\nColheita',
            data: 'OCT 15,\n2023',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: imagemDupla(
                  'https://images.unsplash.com/photo-1546094096-0df4bcaaa337',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: imagemDupla(
                  'https://images.unsplash.com/photo-1518977676601-b53f82aba655',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Meses de rega e espera finalmente valeram a pena. Há algo profundamente gratificante em comer o que você cultivou a partir de uma pequena semente.',
            style: TextStyle(
              color: Color(0xff6e695f),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget imagemDupla(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        image,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget topoCard({
    required String categoria,
    required String titulo,
    required String data,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoria,
                style: const TextStyle(
                  color: Color(0xffba7b81),
                  fontSize: 9,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                style: GoogleFonts.cormorantGaramond(
                  color: const Color(0xff2f2b27),
                  fontSize: 28,
                  height: 0.95,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data,
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
            Icon(
              Icons.more_vert,
              color: Color(0xff9f8f92),
              size: 17,
            ),
            SizedBox(width: 4),
            Icon(
              Icons.bookmark_border,
              color: Color(0xff9f8f92),
              size: 17,
            ),
          ],
        ),
      ],
    );
  }
}

/// CREATE MEMORY PAGE

class CriarMemoriaPage extends StatelessWidget {
  const CriarMemoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xff4e4a45),
                        ),
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

                  const SizedBox(height: 38),

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

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      '25 / 04 / 2026',
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xffa44a62),
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// PHOTO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 210,
                          decoration: BoxDecoration(
                            color: const Color(0xffece8d5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        Positioned(
                          bottom: -12,
                          right: 12,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xfff0e8d8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                              color: Color(0xffb56e7e),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 42),

                  label('TÍTULO DA MEMÓRIA:'),

                  const SizedBox(height: 18),

                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          'O que aconteceu que vale a pena lembrar?',
                      hintStyle: GoogleFonts.cormorantGaramond(
                        color: const Color(0xffc4bbaf),
                        fontSize: 31,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      label('CATEGORIAS'),
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

                  const SizedBox(height: 18),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      tag(
                        'Família',
                        Icons.favorite_border,
                        true,
                      ),
                      tag(
                        'Comida',
                        Icons.restaurant_outlined,
                      ),
                      tag(
                        'Viagem',
                        Icons.flight,
                      ),
                      tag(
                        'Natureza',
                        Icons.eco_outlined,
                      ),
                      tag(
                        'Festa',
                        Icons.celebration_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xfff0edd8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xffd8d8bc),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xff615d55),
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DATA',
                              style: TextStyle(
                                color: Color(0xff8d887e),
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Adicione a data da\nmemória',
                              style: TextStyle(
                                color: Color(0xff4f4b45),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// BUTTON
                  Container(
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
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: bottomBar(1),
    );
  }

  Widget label(String texto) {
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

  Widget tag(
    String texto,
    IconData icon, [
    bool ativo = false,
  ]) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color:
            ativo ? const Color(0xfff3bcc8) : const Color(0xffece8d5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color:
                ativo ? const Color(0xff9f4c62) : const Color(0xff756f64),
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              color:
                  ativo ? const Color(0xff9f4c62) : const Color(0xff756f64),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget bottomBar(int index) {
  return Container(
    height: 78,
    decoration: const BoxDecoration(
      color: Color(0xfff7f4f7),
      border: Border(
        top: BorderSide(
          color: Color(0xffebe5e6),
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navItem(
          Icons.auto_awesome_motion,
          'TIMELINE',
          index == 0,
        ),
        navItem(
          Icons.add_circle_outline,
          'CRIAR',
          index == 1,
        ),
        navItem(
          Icons.sell_outlined,
          'TAGS',
          false,
        ),
        navItem(
          Icons.person_outline,
          'PERFIL',
          false,
        ),
      ],
    ),
  );
}

Widget navItem(
  IconData icon,
  String texto,
  bool ativo,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color:
              ativo ? const Color(0xffece8d5) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color:
              ativo ? const Color(0xffa44a62) : const Color(0xff7e786d),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        texto,
        style: TextStyle(
          color:
              ativo ? const Color(0xffa44a62) : const Color(0xff7e786d),
          fontSize: 9,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}