import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as ap;
import 'signup_screen.dart';
import 'verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<ap.AuthProvider>();

    final success = await authProvider.signIn(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );

    if (!success && mounted) {
      if (authProvider.status == ap.AuthStatus.emailNotVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VerifyEmailScreen(),
          ),
        );
      }
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
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    /// LOGO
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Kigali City",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Text(
                      "Services Directory",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// FORM CARD
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Sign in to continue",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 24),

                          /// EMAIL
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
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
                              if (v == null || v.isEmpty)
                                return "Email required";
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
                              if (v == null || v.isEmpty) {
                                return "Password required";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          /// ERROR MESSAGE
                          Consumer<ap.AuthProvider>(
                            builder: (context, auth, _) {
                              if (auth.errorMessage != null &&
                                  auth.status == ap.AuthStatus.error) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      auth.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),

                          /// LOGIN BUTTON
                          Consumer<ap.AuthProvider>(
                            builder: (context, auth, _) => ElevatedButton(
                              onPressed: auth.isLoading ? null : _signIn,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF2C5364),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: auth.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Sign In",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Sign Up"),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    // Add flexible space to create smooth gradient at bottom
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
