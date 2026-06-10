import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_state.dart';
import 'services/auth_service.dart';
import 'timeline_page.dart';
import 'categories_screen.dart';
import 'create_tag_screen.dart';
import 'create_memory_screen.dart';
import 'register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xffede8d3),
          hintStyle: const TextStyle(color: Color(0xffaaa495), fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffa44a62),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        final user = snapshot.data;

        if (user == null) {
          return const MemoryBoxLogin();
        }

        // Usuário logado — inicia streams do Firestore
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AppState>().startListening();
        });

        return const MainNavigation();
      },
    );
  }
}


class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xfffbf9fb),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xffa44a62),
        ),
      ),
    );
  }
}


class MemoryBoxLogin extends StatefulWidget {
  const MemoryBoxLogin({super.key});

  @override
  State<MemoryBoxLogin> createState() => _MemoryBoxLoginState();
}

class _MemoryBoxLoginState extends State<MemoryBoxLogin> {
  bool _esconderSenha = true;
  bool _carregando = false;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _aviso(String texto, {bool erro = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 3),
        backgroundColor:
            erro ? const Color(0xffb84035) : const Color(0xff4caf50),
      ),
    );
  }

  Future<void> _entrarEmail() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    if (email.isEmpty || senha.isEmpty) {
      _aviso('Preencha e-mail e senha');
      return;
    }
    setState(() => _carregando = true);
    try {
      await AuthService.signInWithEmail(email, senha);
      // AuthWrapper redireciona automaticamente
    } on AuthException catch (e) {
      _aviso(e.message);
    } on FirebaseAuthException catch (e) {
      _aviso(_traduzirErro(e.code));
    } catch (e) {
      _aviso('Erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _entrarGoogle() async {
    setState(() => _carregando = true);
    try {
      await AuthService.signInWithGoogle();
    } on AuthException catch (e) {
      _aviso(e.message);
    } catch (e) {
      _aviso('Erro ao entrar com Google. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _recuperarSenha() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _aviso('Digite seu e-mail para recuperar a senha');
      return;
    }
    try {
      await AuthService.sendPasswordReset(email);
      _aviso('E-mail de recuperação enviado!', erro: false);
    } catch (_) {
      _aviso('Não foi possível enviar o e-mail de recuperação.');
    }
  }

  String _traduzirErro(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'invalid-credential':
        return 'E-mail ou senha inválidos';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um momento.';
      case 'user-disabled':
        return 'Conta desativada. Contate o suporte.';
      default:
        return 'Erro de autenticação ($code)';
    }
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
                    // Logo
                    const Text(
                      'MemoryBox',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Bem-vindo ao seu',
                      style: TextStyle(
                        color: Color(0xff2d2a24),
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Text(
                      'baú de memórias',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Um espaço sagrado para guardar os\nmomentos que o tempo não deve apagar.',
                      style: TextStyle(
                        color: Color(0xff56514a),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Badge domínio
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffa44a62).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xffa44a62).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_outlined,
                              size: 14, color: Color(0xffa44a62)),
                          SizedBox(width: 6),
                          Text(
                            'Acesso restrito: @souunit.com.br',
                            style: TextStyle(
                              color: Color(0xffa44a62),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Card formulário
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 34),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8df),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rotulo('E-MAIL'),
                          const SizedBox(height: 11),
                          _campo(
                            controller: _emailController,
                            hint: 'voce@souunit.com.br',
                            icon: Icons.email_outlined,
                            teclado: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 26),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _rotulo('SENHA'),
                              GestureDetector(
                                onTap: _recuperarSenha,
                                child: const Text(
                                  'Esqueceu?',
                                  style: TextStyle(
                                    color: Color(0xffa44a62),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 11),
                          _campoSenha(),
                          const SizedBox(height: 30),

                          // Botão entrar
                          GestureDetector(
                            onTap: _carregando ? null : _entrarEmail,
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: _carregando
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xffa74860),
                                          Color(0xfff47a9a),
                                        ],
                                      ),
                                color: _carregando
                                    ? const Color(0xffccc)
                                    : null,
                                boxShadow: _carregando
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: const Color(0xffa44a62)
                                              .withOpacity(0.22),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                              ),
                              child: _carregando
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Link cadastro
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Color(0xff4d493f),
                                    fontSize: 15),
                                children: [
                                  const TextSpan(
                                      text: 'Não tem uma conta? '),
                                  WidgetSpan(
                                    alignment:
                                        PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen(),
                                        ),
                                      ),
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

                          const SizedBox(height: 28),
                          _linha(),
                          const SizedBox(height: 24),

                          // Google Sign-In
                          GestureDetector(
                            onTap: _carregando ? null : _entrarGoogle,
                            child: Container(
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xffe0ddd4)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  _googleIcon(),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Entrar com Google',
                                    style: TextStyle(
                                      color: Color(0xff4d493f),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xff5f5a50),
          fontSize: 13,
          letterSpacing: 3.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType teclado,
  }) {
    return TextField(
      controller: controller,
      keyboardType: teclado,
      style: const TextStyle(color: Color(0xff56514a), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            Icon(icon, color: const Color(0xff7b7468), size: 22),
      ),
    );
  }

  Widget _campoSenha() {
    return TextField(
      controller: _senhaController,
      obscureText: _esconderSenha,
      style: const TextStyle(color: Color(0xff56514a), fontSize: 16),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: const TextStyle(
            color: Color(0xffaaa495), fontSize: 20, letterSpacing: 4),
        prefixIcon: const Icon(Icons.lock_outline,
            color: Color(0xff7b7468), size: 22),
        suffixIcon: IconButton(
          onPressed: () =>
              setState(() => _esconderSenha = !_esconderSenha),
          icon: Icon(
            _esconderSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xff7b7468),
          ),
        ),
      ),
    );
  }

  Widget _linha() {
    return Row(
      children: [
        Expanded(
            child: Container(height: 1, color: const Color(0xffe7e1c8))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text('OU',
              style: TextStyle(
                  color: Color(0xff6a655a),
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
        Expanded(
            child: Container(height: 1, color: const Color(0xffe7e1c8))),
      ],
    );
  }

  Widget _googleIcon() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
        border: Border(top: BorderSide(color: Color(0xffebe5e6))),
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
            child: Icon(icon,
                size: 18,
                color: ativo
                    ? const Color(0xffa44a62)
                    : const Color(0xff7e786d)),
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


class MemoryBoxPerfil extends StatefulWidget {
  const MemoryBoxPerfil({super.key});

  @override
  State<MemoryBoxPerfil> createState() => _MemoryBoxPerfilState();
}

class _MemoryBoxPerfilState extends State<MemoryBoxPerfil> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    _nomeController =
        TextEditingController(text: user?.displayName ?? '');
    _emailController =
        TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _aviso(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: erro
          ? const Color(0xffb84035)
          : const Color(0xff4caf50),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _sair() async {
    context.read<AppState>().stopListening();
    await AuthService.signOut();
    // AuthWrapper redireciona para Login automaticamente
  }

  Future<void> _salvarNome() async {
    try {
      await AuthService.currentUser
          ?.updateDisplayName(_nomeController.text.trim());
      _aviso('Nome atualizado!');
    } catch (_) {
      _aviso('Erro ao salvar', erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final isGoogle = user?.providerData
            .any((p) => p.providerId == 'google.com') ??
        false;

    return Scaffold(
      backgroundColor: const Color(0xfffbf9fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
                child: Column(
                  children: [
                    // Logo
                    const Text(
                      'MemoryBox',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Avatar
                    _buildAvatar(user),
                    const SizedBox(height: 20),

                    Text(
                      'Minha Conta',
                      style: GoogleFonts.cormorantGaramond(
                        color: const Color(0xff2d2a24),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // Badge provedor
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: isGoogle
                            ? const Color(0xff4285f4).withOpacity(0.1)
                            : const Color(0xffa44a62).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isGoogle
                            ? 'Conta Google'
                            : 'Conta E-mail / Senha',
                        style: TextStyle(
                          color: isGoogle
                              ? const Color(0xff4285f4)
                              : const Color(0xffa44a62),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Card dados
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8df),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _tituloSecao('NOME'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _nomeController,
                            readOnly: isGoogle,
                            style: const TextStyle(
                                color: Color(0xff4e4a45), fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffede8d3),
                              suffixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Color(0xff7b7468),
                                  size: 22),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _tituloSecao('E-MAIL (INSTITUCIONAL)'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _emailController,
                            readOnly: true, // e-mail não pode ser alterado
                            style: const TextStyle(
                                color: Color(0xff4e4a45), fontSize: 15),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffe8e4d0),
                              suffixIcon: const Icon(Icons.lock_outline,
                                  color: Color(0xffa44a62), size: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                            ),
                          ),

                          if (!isGoogle) ...[
                            const SizedBox(height: 28),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: _salvarNome,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffa44a62),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Stats do usuário
                    _buildStats(context),

                    const SizedBox(height: 40),

                    // Sair
                    GestureDetector(
                      onTap: _sair,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xffece8d5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout,
                                color: Color(0xff56514a), size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Sair da Conta',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(user) {
    final photoUrl = user?.photoURL;
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xfffbf8df), width: 3),
            image: photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                  )
                : null,
            color:
                photoUrl == null ? const Color(0xffede8d3) : null,
          ),
          child: photoUrl == null
              ? const Icon(Icons.person_outline,
                  color: Color(0xff7b7468), size: 50)
              : null,
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      children: [
        _statCard('${state.memories.length}', 'Memórias'),
        const SizedBox(width: 12),
        _statCard('${state.categories.length}', 'Tags'),
      ],
    );
  }

  Widget _statCard(String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xffece8d5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: const Color(0xffa44a62),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xff6b5560),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tituloSecao(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: Color(0xff5f5a50),
        fontSize: 11,
        letterSpacing: 2.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
