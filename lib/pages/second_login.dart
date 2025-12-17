import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../widgets/password_field.dart';

class SecondLogin extends StatefulWidget {
  const SecondLogin({super.key});

  @override
  State<SecondLogin> createState() => _SecondLoginState();
}

class _SecondLoginState extends State<SecondLogin> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final AuthService _authService = AuthService();

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

  String? _validateConfirm(String? value) {
    if (!_submitted) return null;

    if ((value ?? '').isEmpty) return 'Confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';

    return null;
  }


  Future<void> _signUp() async {
    setState(() {
      _submitted = true;
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main_page');

    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _emailError = 'This email is already registered';
            break;

          case 'invalid-email':
            _emailError = 'Invalid email format';
            break;

          case 'weak-password':
            _passwordError = 'Password is too weak (min 6 characters)';
            break;

          default:
            _passwordError = 'Registration failed';
        }
      });

      _formKey.currentState!.validate();

    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
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
                      'Create a new account',
                      style: TextStyle(color: Color(0xFFB8C4D6)),
                    ),
                    const SizedBox(height: 20),

                    const Text('Email',
                        style: TextStyle(color: Color(0xFF7B8CA3))),
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
                        errorStyle:
                        const TextStyle(fontSize: 12, height: 1.2),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text('Password',
                        style: TextStyle(color: Color(0xFF7B8CA3))),
                    const SizedBox(height: 10),
                    PasswordField(
                      controller: _passwordController,
                      validator: _validatePassword,
                    ),

                    const SizedBox(height: 20),
                    const Text('Confirm password',
                        style: TextStyle(color: Color(0xFF7B8CA3))),
                    const SizedBox(height: 10),
                    PasswordField(
                      controller: _confirmController,
                      hint: 'Confirm your password',
                      validator: _validateConfirm,
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Text(
                          'Create account',
                          style:
                          TextStyle(color: Color(0xFF0E2A47)),
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
