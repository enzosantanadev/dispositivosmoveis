import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String _allowedDomain = 'souunit.com.br';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream do usuário atual
  static Stream<User?> get userStream => _auth.authStateChanges();
  static User? get currentUser => _auth.currentUser;
  static String get currentEmail => currentUser?.email ?? '';

  // ── Validação de domínio ────────────────────────────────────────────────
  static bool _isDomainAllowed(String email) {
    return email.toLowerCase().endsWith('@$_allowedDomain');
  }

  static Future<void> _logoutIfDomainInvalid(User user) async {
    if (!_isDomainAllowed(user.email ?? '')) {
      await signOut();
      throw AuthException(
        'Acesso negado. Utilize uma conta @$_allowedDomain',
      );
    }
  }

  // ── E-mail e Senha ──────────────────────────────────────────────────────
  static Future<User?> signInWithEmail(
      String email, String password) async {
    if (!_isDomainAllowed(email)) {
      throw AuthException(
          'Utilize uma conta institucional @$_allowedDomain');
    }
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user;
  }

  static Future<User?> registerWithEmail(
      String name, String email, String password) async {
    if (!_isDomainAllowed(email)) {
      throw AuthException(
          'Utilize uma conta institucional @$_allowedDomain');
    }
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    return cred.user;
  }

  // ── Google Sign-In ──────────────────────────────────────────────────────
  static Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // usuário cancelou

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    await _logoutIfDomainInvalid(cred.user!);
    return cred.user;
  }

  // ── Logout ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ── Reset de senha ──────────────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
}
