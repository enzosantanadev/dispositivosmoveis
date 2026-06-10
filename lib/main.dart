import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app_state.dart';
import 'timeline_page.dart';
import 'categories_screen.dart';
import 'search_screen.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      theme: AppTheme.theme,
      home: const _AuthGate(),
    );
  }
}

// ─── AUTH GATE ───────────────────────────────────────────────────────────────
// Roteamento automático baseado no stream do Firebase Auth.
class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
          );
        }
        return snap.hasData ? const MainShell() : const MemoryBoxLogin();
      },
    );
  }
}

// ─── LOGIN ────────────────────────────────────────────────────────────────────
class MemoryBoxLogin extends StatefulWidget {
  const MemoryBoxLogin({super.key});
  @override
  State<MemoryBoxLogin> createState() => _MemoryBoxLoginState();
}

class _MemoryBoxLoginState extends State<MemoryBoxLogin> {
  final _auth = AuthService();
  bool _esconderSenha = true;
  bool _carregando = false;
  bool _modoLogin = true; // true=login / false=cadastro
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      duration: const Duration(seconds: 3),
      backgroundColor: AppTheme.primaryLight,
    ));
  }

  Future<void> _entrar() async {
    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;
    if (email.isEmpty || senha.isEmpty) { _aviso('Preencha e-mail e senha'); return; }
    setState(() => _carregando = true);
    final res = _modoLogin
        ? await _auth.loginEmailSenha(email, senha)
        : await _auth.cadastrarEmailSenha(email, senha);
    if (mounted) setState(() => _carregando = false);
    if (!res.sucesso) _aviso(res.mensagem!);
    // Se sucesso → _AuthGate detecta e navega automaticamente
  }

  Future<void> _entrarGoogle() async {
    setState(() => _carregando = true);
    final res = await _auth.loginGoogle();
    if (mounted) setState(() => _carregando = false);
    if (!res.sucesso) _aviso(res.mensagem!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                    const Text('MemoryBox',
                        style: TextStyle( //
                          color: AppTheme.primaryLight, fontSize: 35, height: 1.05,
                          fontWeight: FontWeight.w700, fontStyle: FontStyle.italic,
                          fontFamily: 'serif')),
                    const SizedBox(height: 25),
                    const Text('Bem-vindo ao seu',
                        style: TextStyle( //
                          color: AppTheme.textDark, fontSize: 32, height: 1.12,
                          fontWeight: FontWeight.w400, fontFamily: 'serif')),
                    const Text('baú de memórias',
                        style: TextStyle( //
                          color: AppTheme.primaryLight, fontSize: 31, height: 1.2,
                          fontWeight: FontWeight.w400, fontStyle: FontStyle.italic,
                          fontFamily: 'serif')),
                    const SizedBox(height: 27),
                    const Text(
                      'Um espaço sagrado para guardar os\nMomentos que o tempo não deve apagar.',
                      style: TextStyle( //
                        color: AppTheme.textMedium, fontSize: 18,
                        height: 1.42, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 27),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(30, 34, 30, 36),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8df),
                        borderRadius: BorderRadius.circular(38)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text('E-MAIL',
                                style: TextStyle( //
                                  color: AppTheme.textMedium, fontSize: 16,
                                  letterSpacing: 4.2, fontWeight: FontWeight.w500))),
                          const SizedBox(height: 13),
                          _campoTexto(
                            ctrl: _emailCtrl,
                            hint: 'nome@souunit.com.br',
                            icon: Icons.email_outlined,
                            tipo: TextInputType.emailAddress),
                          const SizedBox(height: 31),
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('SENHA',
                                    style: TextStyle( //
                                      color: AppTheme.textMedium, fontSize: 16,
                                      letterSpacing: 4.2, fontWeight: FontWeight.w500)),
                                if (_modoLogin)
                                  GestureDetector(
                                    onTap: () => _aviso('Recuperar senha'),
                                    child: const Text('Esqueceu?',
                                        style: TextStyle( //
                                          color: AppTheme.primaryLight, fontSize: 14,
                                          fontWeight: FontWeight.w500))),
                              ])),
                          const SizedBox(height: 13),
                          _campoSenha(),
                          const SizedBox(height: 33),
                          // ── Botão principal ──────────────────────────────
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _carregando ? null : _entrar,
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient( //
                                  colors: [AppTheme.primary, const Color(0xfff47a9a)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                                boxShadow: [BoxShadow(
                                  color: AppTheme.primaryLight.withValues(alpha: 0.22),
                                  blurRadius: 18, offset: const Offset(0, 10))]),
                              child: _carregando
                                  ? const SizedBox(
                                      width: 24, height: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2.5))
                                  : Text(
                                      _modoLogin ? 'Entrar' : 'Criar conta',
                                      style: const TextStyle(
                                        color: Colors.white, fontSize: 17,
                                        fontWeight: FontWeight.w700)))),
                          const SizedBox(height: 28),
                          // ── Alternar login/cadastro ──────────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () => setState(() => _modoLogin = !_modoLogin),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle( //
                                      color: AppTheme.textDark, fontSize: 15),
                                  children: [
                                    TextSpan(
                                        text: _modoLogin
                                            ? 'Não tem uma conta? '
                                            : 'Já tem conta? '),
                                    TextSpan(
                                        text: _modoLogin
                                            ? 'Criar nova conta'
                                            : 'Fazer login',
                                        style: TextStyle( //
                                          color: AppTheme.primaryLight, fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  ])))),
                          const SizedBox(height: 31),
                          Row(children: [
                            _linha(),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text('OU',
                                  style: TextStyle(
                                    color: AppTheme.textMedium, fontSize: 15,
                                    fontWeight: FontWeight.w700))),
                            _linha(),
                          ]),
                          const SizedBox(height: 26),
                          // ── Google Sign-In ───────────────────────────────
                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: _carregando ? null : _entrarGoogle,
                              child: Container(
                                height: 37,
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                alignment: Alignment.center,
                                decoration: BoxDecoration( //
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(28)),
                                child: _googleTexto()))),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'Apenas contas @souunit.com.br são permitidas',
                              style: TextStyle(
                                color: AppTheme.primaryLight, fontSize: 11),
                              textAlign: TextAlign.center)),
                        ])),
                  ])),
            )),
        ),
      ),
    );
  }

  Widget _campoTexto({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    required TextInputType tipo,
  }) =>
      TextField(
        controller: ctrl,
        keyboardType: tipo,
        style: TextStyle(color: AppTheme.textMedium, fontSize: 17),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.inputBg,
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textLight, fontSize: 17),
          prefixIcon: Icon(icon, color: AppTheme.textMedium, size: 25),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18)));

  Widget _campoSenha() => TextField(
        controller: _senhaCtrl,
        obscureText: _esconderSenha,
        style: TextStyle(color: AppTheme.textMedium, fontSize: 17),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.inputBg,
          hintText: '••••••••',
          hintStyle: TextStyle(
              color: AppTheme.textLight, fontSize: 20, letterSpacing: 4),
          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.textMedium, size: 25),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _esconderSenha = !_esconderSenha),
            icon: Icon(
              _esconderSenha
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppTheme.textMedium)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18)));

  Widget _linha() =>
      Expanded(child: Container(height: 1, color: AppTheme.divider));

  Widget _googleTexto() => RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          children: [
            TextSpan(text: 'G', style: TextStyle(color: Color(0xff4285f4))),
            TextSpan(text: 'o', style: TextStyle(color: Color(0xffdb4437))),
            TextSpan(text: 'o', style: TextStyle(color: Color(0xfff4b400))),
            TextSpan(text: 'g', style: TextStyle(color: Color(0xff4285f4))),
            TextSpan(text: 'l', style: TextStyle(color: Color(0xff0f9d58))),
            TextSpan(text: 'e', style: TextStyle(color: Color(0xffdb4437))),
          ]));
}

// ─── SHELL PRINCIPAL ─────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _idx;
  @override
  void initState() {
    super.initState();
    _idx = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().iniciarStreamTags();
    });
  }

  final _pages = const [
    MemoryTimelinePage(),
    CategoriesScreen(),
    SearchScreen(),
    MemoryBoxPerfil(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _idx, children: _pages),
        bottomNavigationBar: _BottomBar(
            currentIndex: _idx, onTap: (i) => setState(() => _idx = i)));
}
 
class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: AppTheme.background,
          boxShadow: [BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18, offset: const Offset(0, -8))]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(Icons.auto_awesome_motion, 'TIMELINE', 0),
            _item(Icons.sell_outlined, 'TAGS', 1),
            _item(Icons.search, 'BUSCAR', 2),
            _item(Icons.person_outline, 'PERFIL', 3),
          ])));
  }

  Widget _item(IconData icon, String txt, int idx) {
    final ativo = currentIndex == idx;
    return GestureDetector(
      onTap: () => onTap(idx),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 40, height: 36,
          decoration: BoxDecoration(
            color: ativo ? AppTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, size: 20,
              color: ativo ? AppTheme.primary : AppTheme.textMedium)),
        const SizedBox(height: 3),
        Text(txt,
            style: TextStyle(
              color: ativo ? AppTheme.primary : AppTheme.textMedium,
              fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600)),
      ]));
  }
}

// ─── PERFIL ───────────────────────────────────────────────────────────────────
class MemoryBoxPerfil extends StatefulWidget {
  const MemoryBoxPerfil({super.key});
  @override
  State<MemoryBoxPerfil> createState() => _MemoryBoxPerfilState();
}

class _MemoryBoxPerfilState extends State<MemoryBoxPerfil> {
  final _auth = AuthService();
  late final TextEditingController _nomeCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    // ✅ Preenche com dados REAIS do Firebase — sem strings estáticas
    _nomeCtrl = TextEditingController(
        text: user?.displayName ?? user?.email?.split('@').first ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _aviso(String t) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t), backgroundColor: AppTheme.primary,
          duration: const Duration(seconds: 1)));

  Future<void> _sair() async {
    await _auth.logout();
    // _AuthGate detecta o logout e redireciona automaticamente
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
                child: Column(children: [
                  const Text('MemoryBox',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primaryLight, fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic, fontFamily: 'serif')),
                  const SizedBox(height: 46),
                  _avatar(user),
                  const SizedBox(height: 26),
                  const Text('Minha Conta',
                      style: TextStyle( //
                        color: AppTheme.textDark, fontSize: 33,
                        fontWeight: FontWeight.w700, fontFamily: 'serif')),
                  const SizedBox(height: 6),
                  // ✅ E-mail real do Firebase, não string estática
                  Text(user?.email ?? '',
                      style: const TextStyle( //
                          color: AppTheme.textMedium, fontSize: 14)),
                  const SizedBox(height: 52),
                  _dadosConta(),
                  const SizedBox(height: 54),
                  _tituloSecao('CONFIGURAÇÕES'),
                  const SizedBox(height: 17),
                  _opcao('Mudar Senha', Icons.lock_outline,
                      () => _aviso('Mudar senha')),
                  const SizedBox(height: 16),
                  _opcao('Notificações', Icons.notifications_none,
                      () => _aviso('Notificações')),
                  const SizedBox(height: 16),
                  _opcao('Privacidade e Dados', Icons.verified_user_outlined,
                      () => _aviso('Privacidade')),
                  const SizedBox(height: 60),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _sair,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.logout, color: AppTheme.textMedium, size: 25),
                        SizedBox(width: 9),
                        Text('Sair',
                            style: TextStyle( //
                              color: AppTheme.textMedium, fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      ]))),
                  const SizedBox(height: 44),
                  _botaoExcluir(),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'ESTA AÇÃO É PERMANENTE E APAGARÁ TODAS AS SUAS MEMÓRIAS',
                      textAlign: TextAlign.center,
                      style: TextStyle( //
                        color: AppTheme.textLight, fontSize: 10, height: 1.25))),
                ])))))));
  }

  Widget _avatar(User? user) => Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 140, height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.surface,
            border: Border.all(color: AppTheme.background, width: 4)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: user?.photoURL != null
                ? Image.network(user!.photoURL!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.person_outline, color: AppTheme.textMedium, size: 74))
                : const Icon(Icons.person_outline, color: AppTheme.textMedium, size: 74))),
        Positioned(
          right: 4, bottom: 10,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _aviso('Editar foto'),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
              child: const Icon(Icons.edit, color: Colors.white, size: 17)))),
      ]);

  Widget _dadosConta() => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(30)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _tituloCampo('NOME COMPLETO'),
          const SizedBox(height: 11),
          _campo(_nomeCtrl, Icons.person_outline, TextInputType.name),
          const SizedBox(height: 26),
          _tituloCampo('E-MAIL'),
          const SizedBox(height: 11),
          _campo(_emailCtrl, Icons.email_outlined, TextInputType.emailAddress,
              readOnly: true),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => _aviso('Alterações salvas'),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 36),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(22)),
                child: const Text('Salvar Alterações',
                    style: TextStyle(
                      color: Colors.white, fontSize: 15,
                      fontWeight: FontWeight.w600))))),
        ]));

  Widget _tituloCampo(String t) => Text(t,
      style: const TextStyle(
        color: AppTheme.textMedium, fontSize: 13,
        letterSpacing: 3.2, fontWeight: FontWeight.w600));

  Widget _campo(TextEditingController ctrl, IconData icon, TextInputType tipo,
          {bool readOnly = false}) =>
      TextField(
        controller: ctrl,
        keyboardType: tipo,
        readOnly: readOnly,
        style: const TextStyle(color: AppTheme.textMedium, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: readOnly ? AppTheme.surface : AppTheme.inputBg,
          suffixIcon: Icon(icon, color: AppTheme.textMedium, size: 24),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 17)));

  Widget _tituloSecao(String t) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(t,
              style: const TextStyle(
                color: AppTheme.textMedium, fontSize: 13,
                letterSpacing: 2.7, fontWeight: FontWeight.w600))));

  Widget _opcao(String txt, IconData icon, VoidCallback fn) => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: fn,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
            color: AppTheme.inputBg,
            borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(
              width: 45, height: 45,
              decoration:
                  const BoxDecoration(color: AppTheme.surface, shape: BoxShape.circle),
              child: Icon(icon, color: AppTheme.primary, size: 25)),
            const SizedBox(width: 20),
            Expanded(
                child: Text(txt,
                    style: const TextStyle(
                      color: AppTheme.textDark, fontSize: 17,
                      fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right, color: AppTheme.textMedium, size: 28),
          ])));

  Widget _botaoExcluir() => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _aviso('Excluir conta'),
        child: Container(
          width: double.infinity, height: 58,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(14)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.delete_forever_outlined, color: Colors.red.shade800),
            SizedBox(width: 9),
            Text('Excluir Conta',
                style: TextStyle(
                  color: Colors.red.shade800, fontSize: 16,
                  fontWeight: FontWeight.w700)),
          ])));
}
