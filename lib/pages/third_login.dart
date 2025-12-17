import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/password_field.dart';

class ThirdLogin extends StatefulWidget {
  const ThirdLogin({super.key});

  @override
  State<ThirdLogin> createState() => _ThirdLoginState();
}

class _ThirdLoginState extends State<ThirdLogin> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitted = false;
  bool _loading = false;

  String? _emailError;
  String? _passwordError;

  String? _validateEmail(String? value) {
    if (!_submitted) return null;

    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v)) return 'Invalid email format';

    return _emailError;
  }

  String? _validatePassword(String? value) {
    if (!_submitted) return null;

    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';

    return _passwordError;
  }

  Future<void> _login() async {
    setState(() {
      _submitted = true;
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main_page');
    } on FirebaseAuthException catch (e) {
      final email = _emailController.text.trim();
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

      setState(() {
        if (e.code == 'invalid-email' || !emailRegex.hasMatch(email)) {
          _emailError = 'Invalid email format';
        }
        else if (e.code == 'user-not-found') {
          _emailError = 'User with this email does not exist';
        }
        else if (e.code == 'wrong-password') {
          _passwordError = 'Wrong password';
        }
        else if (e.code == 'invalid-credential') {
          _emailError = 'User does not exist or password is incorrect';
          _passwordError = 'User does not exist or password is incorrect';
        }

        else {
          _passwordError = 'Login failed';
        }
      });

      _formKey.currentState!.validate();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign in",
          style: TextStyle(color: Color(0xFFE6EAF0)),
        ),
        backgroundColor: const Color(0xFF163B63),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF163B63)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF163B63),
                  Color(0xFF0E2A47),
                  Color(0xFF081521),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Just sign in to my project',
                      style: TextStyle(
                        color: Color(0xFFB8C4D6),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Email',
                      style: TextStyle(color: Color(0xFF7B8CA3)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F6FA),
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: 'Input your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorStyle: const TextStyle(fontSize: 12, height: 1.2),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(color: Color(0xFF7B8CA3)),
                    ),
                    const SizedBox(height: 10),
                    PasswordField(
                      controller: _passwordController,
                      validator: _validatePassword,
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign in',
                                style: TextStyle(color: Color(0xFF0E2A47)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
