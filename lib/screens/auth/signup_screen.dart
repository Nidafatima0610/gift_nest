import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';

/// Placeholder screen for Sign Up route (/signup).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Join Gift Nest to send personalized gifts with ease.',
                      style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    AppTextField(
                      label: 'Full Name',
                      hintText: 'Jane Doe',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    AppTextField(
                      label: 'Email',
                      hintText: 'hello@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    AppTextField(
                      label: 'Password',
                      hintText: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    AppButton(
                      text: 'Create Account',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              AppButton(
                text: 'Already have an account? Login',
                variant: AppButtonVariant.outline,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
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
