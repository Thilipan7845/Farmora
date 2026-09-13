import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../role_selection/role_selection_screen.dart';
import 'terms_pdf_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String? prefilledEmail;

  const RegisterScreen({
    super.key,
    this.prefilledEmail,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // User can accept Terms only from the PDF screen.
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(
      text: widget.prefilledEmail ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _openTerms() async {
    final accepted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const TermsPdfScreen(),
      ),
    );

    if (!mounted) return;

    if (accepted == true) {
      setState(() {
        _termsAccepted = true;
      });
    }
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please read and accept the Terms & Conditions.',
          ),
        ),
      );
      return;
    }

    // Backend account creation will be connected later.
    // For now, continue to role selection.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.registerTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.registerTitle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  local.registerSubtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                // FULL NAME
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: local.fullName,
                    hintText: local.fullNameHint,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enterFullName;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // MOBILE
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: local.mobileNumber,
                    hintText: local.mobileHint,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return local.enterMobile;
                    }

                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                      return local.validMobile;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // EMAIL
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // PASSWORD
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: local.password,
                    hintText: 'Create a password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.enterPassword;
                    }

                    if (value.length < 6) {
                      return 'Password must contain at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // CONFIRM PASSWORD
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: local.confirmPassword,
                    hintText: local.confirmPasswordHint,
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.confirmPasswordError;
                    }

                    if (value != _passwordController.text) {
                      return local.passwordMismatch;
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                // TERMS
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _termsAccepted
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                    color: _termsAccepted
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.06)
                        : Colors.transparent,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: null,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                              children: [
                                TextSpan(
                                  text: '${local.terms} ',
                                ),
                                TextSpan(
                                  text: local.agreeTerms,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.bold,
                                    decoration:
                                        TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _openTerms,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // OPEN TERMS BUTTON
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _openTerms,
                    icon: const Icon(Icons.description_outlined),
                    label: const Text(
                      'Read Terms & Conditions',
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // CREATE ACCOUNT
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        _termsAccepted ? _createAccount : null,
                    child: Text(
                      local.createAccountButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}