import 'package:flutter/material.dart';
import 'package:heredograma_ici/theme/app_theme.dart';
import 'package:heredograma_ici/widgets/brand_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0.88, end: 1),
            builder: (context, scale, child) => Opacity(
              opacity: ((scale - 0.88) / 0.12).clamp(0, 1),
              child: Transform.scale(scale: scale, child: child),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: BrandLogo(width: 360),
            ),
          ),
        ),
      ),
    );
  }
}

class InitializationErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const InitializationErrorScreen({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandLogo(width: 240),
                const SizedBox(height: 20),
                const Text(
                  'Não foi possível iniciar o aplicativo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
