import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novapay/src/core/utils/validation_utils.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_controller.dart';
import 'package:novapay/src/features/auth/presentation/state/auth_state.dart';

/// Configuration for a form field
class _FormFieldConfig {
  final String key;
  final String label;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool obscure;

  const _FormFieldConfig({
    required this.key,
    required this.label,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
  });
}

/// Signup form field keys - centralized to avoid magic strings
class _SignupFieldKey {
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String bvn = 'bvn';
  static const String nin = 'nin';
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';

  static const List<String> all = [
    firstName,
    lastName,
    email,
    phone,
    bvn,
    nin,
    password,
    confirmPassword,
  ];
}

/// Model to hold form submission data
class _SignupFormData {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String bvn;
  final String nin;

  _SignupFormData({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.bvn,
    required this.nin,
  });
}

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final Map<String, TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Initialize all text controllers
  void _initializeControllers() {
    _controllers = {
      for (final key in _SignupFieldKey.all)
        key: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loading = state is AsyncLoading;

    // Handle navigation on successful authentication
    ref.listen(
      authControllerProvider,
      (_, next) {
        next.whenData((s) {
          if (s is AuthAuthenticated && mounted) {
            context.go('/home');
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join NovaPay',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              ..._buildFormFields(loading),
              const SizedBox(height: 24),
              _buildSignUpButton(loading),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build all form fields
  List<Widget> _buildFormFields(bool loading) {
    final fields = [
      _FormFieldConfig(
        key: _SignupFieldKey.firstName,
        label: 'First Name',
        validator: ValidationUtils.validateFirstName,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.lastName,
        label: 'Last Name',
        validator: ValidationUtils.validateLastName,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.email,
        label: 'Email',
        validator: ValidationUtils.validateEmail,
        keyboardType: TextInputType.emailAddress,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.phone,
        label: 'Phone',
        validator: ValidationUtils.validatePhoneNumber,
        keyboardType: TextInputType.phone,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.bvn,
        label: 'BVN (11 digits)',
        validator: ValidationUtils.validateBVN,
        keyboardType: TextInputType.number,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.nin,
        label: 'NIN (11 digits)',
        validator: ValidationUtils.validateNIN,
        keyboardType: TextInputType.number,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.password,
        label: 'Password',
        validator: ValidationUtils.validatePassword,
        keyboardType: TextInputType.visiblePassword,
        obscure: true,
      ),
      _FormFieldConfig(
        key: _SignupFieldKey.confirmPassword,
        label: 'Confirm Password',
        validator: (value) => ValidationUtils.validatePasswordMatch(
          _controllers[_SignupFieldKey.password]?.text,
          value,
        ),
        keyboardType: TextInputType.visiblePassword,
        obscure: true,
      ),
    ];

    return fields
        .map((config) => _buildTextFormField(config, loading))
        .toList();
  }

  /// Build a single text form field
  Widget _buildTextFormField(_FormFieldConfig config, bool disabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllers[config.key],
        decoration: InputDecoration(
          labelText: config.label,
        ),
        keyboardType: config.keyboardType,
        obscureText: config.obscure,
        validator: config.validator,
        enabled: !disabled,
      ),
    );
  }

  /// Build the sign-up button
  Widget _buildSignUpButton(bool loading) {
    return ElevatedButton(
      onPressed: loading ? null : _handleSignUp,
      child: const Text('Sign Up'),
    );
  }

  /// Handle sign-up form submission
  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final formData = _extractFormData();
    if (formData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process form data')),
        );
      }
      return;
    }

    ref.read(authControllerProvider.notifier).signUp(
          email: formData.email,
          password: formData.password,
          firstName: formData.firstName,
          lastName: formData.lastName,
          phoneNumber: formData.phoneNumber,
          bvn: formData.bvn,
          nin: formData.nin,
        );
  }

  /// Extract form data from controllers
  _SignupFormData? _extractFormData() {
    try {
      return _SignupFormData(
        email: _controllers[_SignupFieldKey.email]?.text ?? '',
        password: _controllers[_SignupFieldKey.password]?.text ?? '',
        firstName: _controllers[_SignupFieldKey.firstName]?.text ?? '',
        lastName: _controllers[_SignupFieldKey.lastName]?.text ?? '',
        phoneNumber: _controllers[_SignupFieldKey.phone]?.text ?? '',
        bvn: _controllers[_SignupFieldKey.bvn]?.text ?? '',
        nin: _controllers[_SignupFieldKey.nin]?.text ?? '',
      );
    } catch (e) {
      debugPrint('Error extracting form data: $e');
      return null;
    }
  }
}
