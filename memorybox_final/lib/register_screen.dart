import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _esconderSenha = true;
  bool _esconderConfirmar = true;
  bool _carregando = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _aviso(String texto, {bool erro = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      duration: const Duration(seconds: 3),
      backgroundColor:
          erro ? const Color(0xffb84035) : const Color(0xff4caf50),
    ));
  }

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmar = _confirmarController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      _aviso('Preencha todos os campos');
      return;
    }
    if (senha != confirmar) {
      _aviso('As senhas não coincidem');
      return;
    }
    if (senha.length < 6) {
      _aviso('A senha deve ter pelo menos 6 caracteres');
      return;
    }

    setState(() => _carregando = true);
    try {
      await AuthService.registerWithEmail(nome, email, senha);
      // AuthWrapper redireciona automaticamente para MainNavigation
      if (mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      _aviso(e.message);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _aviso('Este e-mail já está cadastrado');
          break;
        case 'weak-password':
          _aviso('Senha muito fraca. Use pelo menos 6 caracteres');
          break;
        case 'invalid-email':
          _aviso('Formato de e-mail inválido');
          break;
        default:
          _aviso('Erro ao criar conta (${e.code})');
      }
    } catch (_) {
      _aviso('Erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbf9fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 48, 28, 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Voltar
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xffede8d3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Color(0xff5f5a50), size: 15),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Logo
                    const Text(
                      'MemoryBox',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Crie sua conta',
                      style: TextStyle(
                        color: Color(0xff2d2a24),
                        fontSize: 28,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Text(
                      'e guarde seus momentos',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Badge domínio obrigatório
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffa44a62).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                const Color(0xffa44a62).withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline,
                              size: 13, color: Color(0xffa44a62)),
                          SizedBox(width: 6),
                          Text(
                            'Necessário e-mail @souunit.com.br',
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
                      padding: const EdgeInsets.fromLTRB(26, 30, 26, 32),
                      decoration: BoxDecoration(
                        color: const Color(0xfffbf8df),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rotulo('NOME COMPLETO'),
                          const SizedBox(height: 10),
                          _campo(
                            controller: _nomeController,
                            hint: 'Seu nome',
                            icon: Icons.person_outline,
                            teclado: TextInputType.name,
                          ),
                          const SizedBox(height: 22),

                          _rotulo('E-MAIL INSTITUCIONAL'),
                          const SizedBox(height: 10),
                          _campo(
                            controller: _emailController,
                            hint: 'voce@souunit.com.br',
                            icon: Icons.email_outlined,
                            teclado: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 22),

                          _rotulo('SENHA'),
                          const SizedBox(height: 10),
                          _campoSenha(
                            controller: _senhaController,
                            hint: '••••••••',
                            esconder: _esconderSenha,
                            onToggle: () => setState(
                                () => _esconderSenha = !_esconderSenha),
                          ),
                          const SizedBox(height: 22),

                          _rotulo('CONFIRMAR SENHA'),
                          const SizedBox(height: 10),
                          _campoSenha(
                            controller: _confirmarController,
                            hint: '••••••••',
                            esconder: _esconderConfirmar,
                            onToggle: () => setState(() =>
                                _esconderConfirmar = !_esconderConfirmar),
                          ),

                          const SizedBox(height: 32),

                          // Botão criar
                          GestureDetector(
                            onTap: _carregando ? null : _cadastrar,
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: _carregando
                                    ? null
                                    : const LinearGradient(colors: [
                                        Color(0xffa74860),
                                        Color(0xfff47a9a),
                                      ]),
                                color: _carregando
                                    ? const Color(0xffcccccc)
                                    : null,
                                boxShadow: _carregando
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: const Color(0xffa44a62)
                                              .withOpacity(0.22),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        )
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
                                      'Criar Conta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Color(0xff4d493f),
                                    fontSize: 15),
                                children: [
                                  const TextSpan(
                                      text: 'Já tem uma conta? '),
                                  WidgetSpan(
                                    alignment:
                                        PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () =>
                                          Navigator.pop(context),
                                      child: const Text(
                                        'Entrar',
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

  Widget _rotulo(String texto) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xff5f5a50),
            fontSize: 12,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _campo({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType teclado,
  }) =>
      TextField(
        controller: controller,
        keyboardType: teclado,
        style: const TextStyle(color: Color(0xff56514a), fontSize: 15),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffede8d3),
          hintText: hint,
          hintStyle:
              const TextStyle(color: Color(0xffaaa495), fontSize: 15),
          prefixIcon:
              Icon(icon, color: const Color(0xff7b7468), size: 21),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      );

  Widget _campoSenha({
    required TextEditingController controller,
    required String hint,
    required bool esconder,
    required VoidCallback onToggle,
  }) =>
      TextField(
        controller: controller,
        obscureText: esconder,
        style: const TextStyle(color: Color(0xff56514a), fontSize: 15),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffede8d3),
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xffaaa495), fontSize: 20, letterSpacing: 4),
          prefixIcon: const Icon(Icons.lock_outline,
              color: Color(0xff7b7468), size: 21),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              esconder
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: const Color(0xff7b7468),
              size: 21,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      );
}
