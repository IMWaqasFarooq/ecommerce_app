import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/auth_controller_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_sign_in_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authControllerProvider.notifier)
        .signInWithEmailPassword(email: _emailController.text, password: _passwordController.text);
  }

  void _forgotPassword() {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enterEmailAboveFirst)));
      return;
    }
    ref.read(authControllerProvider.notifier).sendPasswordResetEmail(email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.passwordResetEmailSent(email))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controllerState = ref.watch(authControllerProvider);
    final isLoading = controllerState.isLoading;
    final scheme = Theme.of(context).colorScheme;

    ref.listen(authControllerProvider, (previous, next) {
      final error = next.error;
      if (next.hasError && !next.isLoading && error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.localizedMessage(context))));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.storefront_rounded, size: 56, color: scheme.primary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.welcomeBack,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.signInSubtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AuthTextField(
                      controller: _emailController,
                      label: l10n.emailLabel,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        if (value == null || value.isEmpty) return l10n.enterYourEmail;
                        if (!value.contains('@')) return l10n.enterValidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AuthTextField(
                      controller: _passwordController,
                      label: l10n.passwordLabel,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        if (value == null || value.length < 6) return l10n.atLeast6Characters;
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading ? null : _forgotPassword,
                        child: Text(l10n.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : Text(l10n.signIn),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          child: Text(l10n.orDivider, style: Theme.of(context).textTheme.labelSmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SocialSignInButton(
                      label: l10n.continueWithGoogle,
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                      onPressed: isLoading
                          ? null
                          : () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(height: AppSpacing.sm),
                      SocialSignInButton(
                        label: l10n.continueWithApple,
                        icon: const Icon(Icons.apple_rounded, size: 22),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        onPressed: isLoading
                            ? null
                            : () => ref.read(authControllerProvider.notifier).signInWithApple(),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(l10n.dontHaveAccount),
                        TextButton(
                          onPressed: isLoading ? null : () => context.push(RoutePaths.signup),
                          child: Text(l10n.signUp),
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
    );
  }
}
