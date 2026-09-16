import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/user_model.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bvnController = TextEditingController();
  final _ninController = TextEditingController();

  @override
  void dispose() {
    for (var c in [
      _firstNameController,
      _lastNameController,
      _emailController,
      _passwordController,
      _bvnController,
      _ninController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

String _generateAccountNumber() {
  final random = Random();
  // Ensure the first digit is not 0 so it stays a true 10-digit sequence
  String accountNumber = (random.nextInt(9) + 1).toString(); 
  
  // Append 9 more random digits
  for (int i = 0; i < 9; i++) {
    accountNumber += random.nextInt(10).toString();
  }
  
  return accountNumber;
}


  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final userModel = UserModel(
      id: '',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      accountNumber: _generateAccountNumber(),
      bvn: _bvnController.text.trim(),
      nin: _ninController.text.trim(),
      walletBalanceInKobo: 2500000,
      kycTier: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final controller = ref.read(authControllerProvider.notifier);
    await controller.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      user: userModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed: ${next.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(
                    'Join NovaPay',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Semantics(
                  label: 'First name',
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (v) =>
                        v?.trim().isEmpty ?? true ? 'Required' : null,
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Last name',
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (v) =>
                        v?.trim().isEmpty ?? true ? 'Required' : null,
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Email',
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => v?.contains('@') ?? false
                        ? null
                        : 'Valid email required',
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Password',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (v) =>
                        (v?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'BVN',
                  child: TextFormField(
                    controller: _bvnController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'BVN'),
                    validator: (v) =>
                        (v?.length ?? 0) == 11 ? null : '11 digits',
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'NIN',
                  child: TextFormField(
                    controller: _ninController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'NIN'),
                    validator: (v) =>
                        (v?.length ?? 0) >= 10 ? null : 'Valid NIN',
                    enabled: !isLoading,
                  ),
                ),
                const SizedBox(height: 32),
                Semantics(
                  button: true,
                  label: 'Create Account',
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('CREATE ACCOUNT'),
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.go('/login'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text('Already have an account? Login'),
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
