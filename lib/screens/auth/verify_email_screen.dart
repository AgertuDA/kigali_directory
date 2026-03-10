import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as ap;
import '../../theme.dart';
import '../../home_screen.dart';
import 'login_screen.dart';

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> {
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedOpacity(
          opacity: index < _dotCount ? 1.0 : 0.3,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            '.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _listenAuthState();
  }

  void _listenAuthState() {
    // Listen to auth state changes and navigate when verified
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<ap.AuthProvider>();
      auth.addListener(_onAuthStateChanged);
    });
  }

  void _onAuthStateChanged() {
    final auth = context.read<ap.AuthProvider>();
    if (auth.status == ap.AuthStatus.authenticated) {
      // Remove listener before navigating
      auth.removeListener(_onAuthStateChanged);
      // Navigate to home (directory) when email is verified
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (mounted) {
        await context.read<ap.AuthProvider>().checkEmailVerification();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Remove auth listener to prevent memory leaks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ap.AuthProvider>().removeListener(_onAuthStateChanged);
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<ap.AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.email_outlined,
                    color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 32),
              const Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a verification link to\n${auth.user?.email ?? "your email"}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please check your inbox and click the link to verify your account. Check your spam folder if not recieved. This page will update automatically.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 40),
              _LoadingDots(),
              const SizedBox(height: 16),
              const Text(
                'Waiting for verification...',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 40),
              if (_emailSent)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Verification email sent! Check your spam folder if not received.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.success, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await context
                      .read<ap.AuthProvider>()
                      .resendVerificationEmail();
                  setState(() => _emailSent = true);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Verification email resent!')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Resend Email'),
              ),
              TextButton(
                onPressed: () async {
                  await context.read<ap.AuthProvider>().signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                child: const Text('Back to Login',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
