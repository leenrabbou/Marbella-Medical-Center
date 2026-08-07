import 'package:flutter/material.dart';
import 'package:marbella/features/shared/settings/views/home_view.dart';
import 'package:marbella/core/databases/cache/cache_keys.dart';
import 'package:marbella/core/databases/cache/cache_service.dart';
import 'package:marbella/features/shared/auth/viewmodels/auth_viewmodel.dart';
import 'package:marbella/features/shared/auth/views/login_view.dart';
import 'package:marbella/features/shared/auth/views/verification/verification_required_view.dart';
import 'package:marbella/features/shared/settings/views/onboarding_view.dart';
import 'package:marbella/generated/l10n.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOutBack),
      ),
    );
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOutQuad),
      ),
    );
    _controller.forward();

    _prepareAndNavigate();
  }

  Future<void> _prepareAndNavigate() async {
    final auth = context.read<AuthViewmodel>();
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      auth.loadUser(),
    ]);

    if (!mounted) return;

    String? phone =
        auth.response?.data?.phoneNumber ??
        auth.userFromCache?.data?.phoneNumber;
    bool? val = CacheService().getData(key: CacheKeys.onBoarding);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return auth.isLoggedIn
              ? auth.isVerified
                    ? val == true
                          ? HomeView()
                          : OnboardingView()
                    : VerificationRequiredView(
                        phone: phone ?? S.of(context).invalid_number,
                      )
              : LoginView();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _gradientAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5 * _gradientAnimation.value,
                    colors: [
                      colorScheme.primary.withAlpha((0.08 * 255).toInt()),
                      Colors.white,
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _controller.value.clamp(0.0, 1.0),
                      child: ScaleTransition(
                        scale: _logoAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(
                            (0.15 * 255).toInt(),
                          ),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/imglogo1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - _textAnimation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Marbella',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          letterSpacing: 1.5,
                          fontFamily: 'AlexBrush',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        S().app_slogan,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
