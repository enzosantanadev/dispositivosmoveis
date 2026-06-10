import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Serviço de autenticação Firebase.
/// Regra de domínio: apenas @souunit.com.br é aceito.
class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  static const _dominio = '@souunit.com.br';

  // ── Getters ─────────────────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// E-mail do usuário logado — usado na amarração dinâmica dos documentos.
  String get emailAtual => _auth.currentUser?.email ?? '';

  // ── Validação de domínio ─────────────────────────────────────────────────
  static bool _dominioValido(String? email) =>
      email != null && email.trim().endsWith(_dominio);

  // ── Login com E-mail e Senha ─────────────────────────────────────────────
  Future<AuthResultado> loginEmailSenha(String email, String senha) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: senha);
      if (!_dominioValido(cred.user?.email)) {
        await _auth.signOut();
        return AuthResultado.erro(
            'Acesso negado. Use uma conta @souunit.com.br.');
      }
      return AuthResultado.ok(cred.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResultado.erro(_traduzirErro(e.code));
    }
  }

  // ── Cadastro com E-mail e Senha ──────────────────────────────────────────
  Future<AuthResultado> cadastrarEmailSenha(String email, String senha) async {
    if (!_dominioValido(email.trim())) {
      return AuthResultado.erro(
          'Apenas e-mails @souunit.com.br podem se cadastrar.');
    }
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: senha);
      return AuthResultado.ok(cred.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResultado.erro(_traduzirErro(e.code));
    }
  }

  // ── Login com Google ─────────────────────────────────────────────────────
  Future<AuthResultado> loginGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        return AuthResultado.erro('Login cancelado pelo usuário.');
      }

      // Validação de domínio ANTES de criar sessão Firebase
      if (!_dominioValido(googleUser.email)) {
        await _google.signOut();
        return AuthResultado.erro(
            'Acesso negado. Use uma conta Google @souunit.com.br.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);

      // Segunda verificação após autenticação (segurança dupla)
      if (!_dominioValido(userCred.user?.email)) {
        await logout();
        return AuthResultado.erro('Domínio não autorizado. Logout realizado.');
      }
      return AuthResultado.ok(userCred.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResultado.erro(_traduzirErro(e.code));
    } catch (e) {
      return AuthResultado.erro('Erro inesperado: $e');
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await Future.wait([_google.signOut(), _auth.signOut()]);
  }

  // ── Tradução de erros Firebase ───────────────────────────────────────────
  static String _traduzirErro(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'email-already-in-use':
        return 'E-mail já cadastrado.';
      case 'weak-password':
        return 'Senha muito fraca. Use ao menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro de autenticação ($code).';
    }
  }
}

// ── Classe de resultado ──────────────────────────────────────────────────────
class AuthResultado {
  final bool sucesso;
  final String? mensagem;
  final User? usuario;

  const AuthResultado._({required this.sucesso, this.mensagem, this.usuario});

  factory AuthResultado.ok(User usuario) =>
      AuthResultado._(sucesso: true, usuario: usuario);

  factory AuthResultado.erro(String mensagem) =>
      AuthResultado._(sucesso: false, mensagem: mensagem);
}
