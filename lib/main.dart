import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'timeline_page.dart';
import 'categories_screen.dart';
import 'search_screen.dart';
import 'create_tag_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MemoryBoxApp(),
    ),
  );
}

class MemoryBoxApp extends StatelessWidget {
  const MemoryBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfffbf9fb),
      ),
      home: const MemoryBoxLogin(),
    );
  }
}

// ─────────────────────────────────────────────
// TELA DE LOGIN
// ─────────────────────────────────────────────
class MemoryBoxLogin extends StatefulWidget {
  const MemoryBoxLogin({super.key});

  @override
  State<MemoryBoxLogin> createState() => _MemoryBoxLoginState();
}

class _MemoryBoxLoginState extends State<MemoryBoxLogin> {
  bool esconderSenha = true;
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xffa44a62),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 76, 28, 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MemoryBox',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 35,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Bem-vindo ao seu',
                      style: TextStyle(
                        color: Color(0xff2d2a24),
                        fontSize: 32,
                        height: 1.12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Text(
                      'baú de memórias',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 31,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 27),
                    const Text(
                      'Um espaço sagrado para guardar os\nmonentos que o tempo não deve apagar.',
                      style: TextStyle(
                        color: Color(0xff56514a),
                        fontSize: 18,
                        height: 1.42,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 27),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(30, 34, 30, 36),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8df),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              'E-MAIL',
                              style: TextStyle(
                                color: Color(0xff5f5a50),
                                fontSize: 16,
                                letterSpacing: 4.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 13),
                          campoTexto(
                            controller: emailController,
                            hint: 'seu@email.com',
                            icon: Icons.email_outlined,
                            teclado: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 31),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 4, right: 12),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SENHA',
                                  style: TextStyle(
                                    color: Color(0xff5f5a50),
                                    fontSize: 16,
                                    letterSpacing: 4.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => aviso('Recuperar senha'),
                                  child: const Text(
                                    'Esqueceu?',
                                    style: TextStyle(
                                      color: Color(0xffa44a62),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 13),
                          campoSenha(),
                          const SizedBox(height: 33),
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainNavigation(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffa74860),
                                    Color(0xfff47a9a),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xffa44a62)
                                        .withOpacity(0.22),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xff4d493f),
                                  fontSize: 15,
                                ),
                                children: [
                                  const TextSpan(text: 'Não tem uma conta? '),
                                  WidgetSpan(
                                    alignment:
                                    PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () =>
                                          aviso('Criar nova conta'),
                                      child: const Text(
                                        'Criar nova conta',
                                        style: TextStyle(
                                          color: Color(0xffa44a62),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 31),
                          Row(
                            children: [
                              linha(),
                              const Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  'OU',
                                  style: TextStyle(
                                    color: Color(0xff6a655a),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              linha(),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () => aviso('Entrar com Google'),
                              child: Container(
                                height: 37,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xffeee9d7),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: googleTexto(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTexto({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType teclado,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      style: const TextStyle(color: Color(0xff56514a), fontSize: 17),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffede8d3),
        hintText: hint,
        hintStyle:
        const TextStyle(color: Color(0xffaaa495), fontSize: 17),
        prefixIcon:
        Icon(icon, color: const Color(0xff7b7468), size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 18),
      ),
    );
  }

  Widget campoSenha() {
    return TextField(
      controller: senhaController,
      obscureText: esconderSenha,
      style: const TextStyle(color: Color(0xff56514a), fontSize: 17),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffede8d3),
        hintText: '••••••••',
        hintStyle: const TextStyle(
          color: Color(0xffaaa495),
          fontSize: 20,
          letterSpacing: 4,
        ),
        prefixIcon: const Icon(Icons.lock_outline,
            color: Color(0xff7b7468), size: 25),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              esconderSenha = !esconderSenha;
            });
          },
          icon: Icon(
            esconderSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xff7b7468),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 18),
      ),
    );
  }

  Widget linha() {
    return Expanded(
      child:
      Container(height: 1, color: const Color(0xffe7e1c8)),
    );
  }

  Widget googleTexto() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        children: [
          TextSpan(text: 'G', style: TextStyle(color: Color(0xff4285f4))),
          TextSpan(text: 'o', style: TextStyle(color: Color(0xffdb4437))),
          TextSpan(text: 'o', style: TextStyle(color: Color(0xfff4b400))),
          TextSpan(text: 'g', style: TextStyle(color: Color(0xff4285f4))),
          TextSpan(text: 'l', style: TextStyle(color: Color(0xff0f9d58))),
          TextSpan(text: 'e', style: TextStyle(color: Color(0xffdb4437))),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAVEGAÇÃO PRINCIPAL (Bottom Nav)
// ─────────────────────────────────────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MemoryTimelinePage(),
    CreateTagScreen(),
    CategoriesScreen(),
    MemoryBoxPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Color(0xfff7f4f7),
        border: Border(
          top: BorderSide(color: Color(0xffebe5e6)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.auto_awesome_motion, 'TIMELINE', 0),
          _navItem(Icons.add_circle_outline, 'CRIAR', 1),
          _navItem(Icons.sell_outlined, 'TAGS', 2),
          _navItem(Icons.person_outline, 'PERFIL', 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String texto, int index) {
    final ativo = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ativo
                  ? const Color(0xffece8d5)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: ativo
                  ? const Color(0xffa44a62)
                  : const Color(0xff7e786d),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              color: ativo
                  ? const Color(0xffa44a62)
                  : const Color(0xff7e786d),
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TELA DE PERFIL
// ─────────────────────────────────────────────
class MemoryBoxPerfil extends StatefulWidget {
  const MemoryBoxPerfil({super.key});

  @override
  State<MemoryBoxPerfil> createState() => _MemoryBoxPerfilState();
}

class _MemoryBoxPerfilState extends State<MemoryBoxPerfil> {
  final nomeController =
  TextEditingController(text: 'Helena Ferreira');
  final emailPerfilController =
  TextEditingController(text: 'helena.ferreira@example.com');

  @override
  void dispose() {
    nomeController.dispose();
    emailPerfilController.dispose();
    super.dispose();
  }

  void aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xffa44a62),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
                child: Column(
                  children: [
                    const Text(
                      'MemoryBox',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 28,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 46),
                    avatar(),
                    const SizedBox(height: 26),
                    const Text(
                      'Minha Conta',
                      style: TextStyle(
                        color: Color(0xff2d2a24),
                        fontSize: 33,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Membro desde Outubro 2023',
                      style: TextStyle(
                          color: Color(0xff56514a), fontSize: 17),
                    ),
                    const SizedBox(height: 52),
                    dadosConta(),
                    const SizedBox(height: 54),
                    tituloSecao('CONFIGURAÇÕES'),
                    const SizedBox(height: 17),
                    opcaoConfiguracao(
                      texto: 'Mudar Senha',
                      icon: Icons.lock_outline,
                      onTap: () => aviso('Mudar senha'),
                    ),
                    const SizedBox(height: 16),
                    opcaoConfiguracao(
                      texto: 'Notificações',
                      icon: Icons.notifications_none,
                      onTap: () => aviso('Notificações'),
                    ),
                    const SizedBox(height: 16),
                    opcaoConfiguracao(
                      texto: 'Privacidade e Dados',
                      icon: Icons.verified_user_outlined,
                      onTap: () => aviso('Privacidade e dados'),
                    ),
                    const SizedBox(height: 72),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => aviso('Sair da conta'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout,
                                color: Color(0xff56514a), size: 25),
                            SizedBox(width: 9),
                            Text(
                              'Sair',
                              style: TextStyle(
                                color: Color(0xff56514a),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    botaoExcluirConta(),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'ESTA AÇÃO É PERMANENTE E APAGARÁ TODAS AS SUAS MEMÓRIAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff8b887d),
                          fontSize: 10,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget avatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xfffbf8df), width: 4),
          ),
          child: const Icon(Icons.person_outline,
              color: Color(0xff565d47), size: 74),
        ),
        Positioned(
          right: 4,
          bottom: 10,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => aviso('Editar foto'),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xffa44a62),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                    const Color(0xffa44a62).withOpacity(0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.edit,
                  color: Colors.white, size: 17),
            ),
          ),
        ),
      ],
    );
  }

  Widget dadosConta() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
      decoration: BoxDecoration(
        color: const Color(0xfffbf8df),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tituloCampo('NOME COMPLETO'),
          const SizedBox(height: 11),
          campoPerfil(
            controller: nomeController,
            icon: Icons.person_outline,
            teclado: TextInputType.name,
          ),
          const SizedBox(height: 26),
          tituloCampo('E-MAIL'),
          const SizedBox(height: 11),
          campoPerfil(
            controller: emailPerfilController,
            icon: Icons.email_outlined,
            teclado: TextInputType.emailAddress,
          ),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => aviso('Alterações salvas'),
              child: Container(
                height: 48,
                padding:
                const EdgeInsets.symmetric(horizontal: 36),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffa44a62),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tituloCampo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Color(0xff5f5a50),
        fontSize: 13,
        letterSpacing: 3.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget campoPerfil({
    required TextEditingController controller,
    required IconData icon,
    required TextInputType teclado,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      style:
      const TextStyle(color: Color(0xff56514a), fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffede8d3),
        suffixIcon:
        Icon(icon, color: const Color(0xff7b7468), size: 24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 17),
      ),
    );
  }

  Widget tituloSecao(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 26),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xff56514a),
            fontSize: 13,
            letterSpacing: 2.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget opcaoConfiguracao({
    required String texto,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          color: const Color(0xffede8d3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xfffbf8df),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: const Color(0xffa44a62), size: 25),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  color: Color(0xff3f3b34),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color(0xff7b7468), size: 28),
          ],
        ),
      ),
    );
  }

  Widget botaoExcluirConta() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => aviso('Excluir conta'),
      child: Container(
        width: double.infinity,
        height: 58,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xffffdcdc),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever_outlined,
                color: Color(0xffb84035)),
            SizedBox(width: 9),
            Text(
              'Excluir Conta',
              style: TextStyle(
                color: Color(0xffb84035),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}