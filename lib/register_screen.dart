import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _esconderSenha = true;
  bool _esconderConfirmar = true;
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

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xffa44a62),
      ),
    );
  }

  void _cadastrar() {
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
    _aviso('Conta criada com sucesso!');
    Navigator.pop(context);
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
                padding: const EdgeInsets.fromLTRB(28, 52, 28, 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botão voltar
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xffede8d3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xff5f5a50),
                          size: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Logo
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

                    const SizedBox(height: 14),

                    const Text(
                      'Crie sua conta',
                      style: TextStyle(
                        color: Color(0xff2d2a24),
                        fontSize: 30,
                        height: 1.12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Text(
                      'e guarde seus momentos',
                      style: TextStyle(
                        color: Color(0xffa44a62),
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'serif',
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Um lugar sagrado para as memórias\nque merecem ser lembradas.',
                      style: TextStyle(
                        color: Color(0xff56514a),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Card do formulário
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
                          // NOME
                          _rotulo('NOME COMPLETO'),
                          const SizedBox(height: 11),
                          _campo(
                            controller: _nomeController,
                            hint: 'Seu nome',
                            icon: Icons.person_outline,
                            teclado: TextInputType.name,
                          ),
                          const SizedBox(height: 24),

                          // EMAIL
                          _rotulo('E-MAIL'),
                          const SizedBox(height: 11),
                          _campo(
                            controller: _emailController,
                            hint: 'seu@email.com',
                            icon: Icons.email_outlined,
                            teclado: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),

                          // SENHA
                          _rotulo('SENHA'),
                          const SizedBox(height: 11),
                          _campoSenha(
                            controller: _senhaController,
                            hint: '••••••••',
                            esconder: _esconderSenha,
                            onToggle: () => setState(
                                () => _esconderSenha = !_esconderSenha),
                          ),
                          const SizedBox(height: 24),

                          // CONFIRMAR SENHA
                          _rotulo('CONFIRMAR SENHA'),
                          const SizedBox(height: 11),
                          _campoSenha(
                            controller: _confirmarController,
                            hint: '••••••••',
                            esconder: _esconderConfirmar,
                            onToggle: () => setState(() =>
                                _esconderConfirmar = !_esconderConfirmar),
                          ),
                          const SizedBox(height: 34),

                          // Botão cadastrar
                          GestureDetector(
                            onTap: _cadastrar,
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
                                'Criar Conta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xff4d493f),
                                  fontSize: 15,
                                ),
                                children: [
                                  const TextSpan(text: 'Já tem uma conta? '),
                                  WidgetSpan(
                                    alignment:
                                        PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
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
        filled: true,
        fillColor: const Color(0xffede8d3),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xffaaa495), fontSize: 16),
        prefixIcon: Icon(icon, color: const Color(0xff7b7468), size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      ),
    );
  }

  Widget _campoSenha({
    required TextEditingController controller,
    required String hint,
    required bool esconder,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: esconder,
      style: const TextStyle(color: Color(0xff56514a), fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffede8d3),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xffaaa495),
          fontSize: 20,
          letterSpacing: 4,
        ),
        prefixIcon: const Icon(Icons.lock_outline,
            color: Color(0xff7b7468), size: 22),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            esconder
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xff7b7468),
            size: 22,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      ),
    );
  }
}
