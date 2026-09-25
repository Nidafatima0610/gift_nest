import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';

/// Polished boutique Signup screen for Gift Nest.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  void _handleGuestBrowsing() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _navigateToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Boutique Brand Crest / Emblem
              Center(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 26,
                      color: AppColors.softRose,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.md),

              // Header Presentation
              const Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              const Text(
                'Start discovering thoughtful gifts made just for your special people.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryText,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: AppDimensions.lg),

              // Form Section in Boutique Card
              AppCard(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      AppTextField(
                        label: 'Full Name',
                        hintText: 'e.g. Jane Doe',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                        validator: Validators.name,
                      ),

                      const SizedBox(height: AppDimensions.md),

                      // Email Field
                      AppTextField(
                        label: 'Email',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                        validator: Validators.email,
                      ),

                      const SizedBox(height: AppDimensions.md),

                      // Password Field with Visibility Toggle
                      AppTextField(
                        label: 'Password',
                        hintText: 'Create a password (min. 6 characters)',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          key: const Key('signup_password_visibility_toggle'),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.secondaryText,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                        validator: Validators.password,
                      ),

                      const SizedBox(height: AppDimensions.md),

                      // Confirm Password Field with Visibility Toggle
                      AppTextField(
                        label: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignup(),
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          key: const Key('signup_confirm_password_visibility_toggle'),
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.secondaryText,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          tooltip: _obscureConfirmPassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),

                      const SizedBox(height: AppDimensions.lg),

                      // Primary Button ("Create Account")
                      AppButton(
                        text: 'Create Account',
                        onPressed: _handleSignup,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.md),

              // Switch to Log In
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  GestureDetector(
                    key: const Key('signup_to_login_button'),
                    onTap: _navigateToLogin,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.lg),

              // Divider with "OR"
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.border, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText.withValues(alpha: 0.85),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.border, thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.lg),

              // Visually Secondary Option: "Continue as Guest"
              AppButton(
                key: const Key('signup_continue_as_guest'),
                text: 'Continue as Guest',
                variant: AppButtonVariant.outline,
                icon: Icons.person_outline_rounded,
                onPressed: _handleGuestBrowsing,
              ),

              const SizedBox(height: AppDimensions.xs + 2),

              const Text(
                'Explore thoughtful gifts and creators without an account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),

              const SizedBox(height: AppDimensions.lg),
            ],
          ),
        ),
      ),
    );
  }
}
