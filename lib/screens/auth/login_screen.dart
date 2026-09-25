import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';

/// Placeholder screen for Login route (/login).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign in to manage your gifts, boxes, and orders.',
                      style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    AppTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    AppTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    AppButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              AppButton(
                text: "Don't have an account? Sign Up",
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
              ),
              const SizedBox(height: AppDimensions.sm),
              AppButton(
                text: 'Continue to Home',
                variant: AppButtonVariant.text,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
