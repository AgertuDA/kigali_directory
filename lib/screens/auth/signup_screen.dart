import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as ap;
import 'verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<ap.AuthProvider>().signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          displayName: _nameCtrl.text.trim(),
        );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const VerifyEmailScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Join Kigali City Directory",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 24),

                      /// NAME
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF2C5364),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Name required" : null,
                      ),

                      const SizedBox(height: 16),

                      /// EMAIL
                      TextFormField(
                        controller: _emailCtrl,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF2C5364),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Email required";
                          if (!v.contains("@")) return "Enter valid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF2C5364),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return "Password required";
                          if (v.length < 6) return "Minimum 6 characters";
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// CONFIRM PASSWORD
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscureConfirm,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF2C5364),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Confirm password";
                          if (v != _passwordCtrl.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      /// SIGNUP BUTTON
                      Consumer<ap.AuthProvider>(
                        builder: (context, auth, _) => ElevatedButton(
                          onPressed: auth.isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF2C5364),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: auth.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Create Account",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Log In"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
