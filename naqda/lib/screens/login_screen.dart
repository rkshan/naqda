import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();

  bool _isPhoneMode = false;
  String? _verificationId;
  String? _error;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Use Phone (OTP) login'),
              value: _isPhoneMode,
              onChanged: (v) => setState(() => _isPhoneMode = v),
            ),
            if (!_isPhoneMode) ...[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        try {
                          await auth.signInWithEmail(
                              _emailController.text.trim(), _passwordController.text.trim());
                        } catch (e) {
                          setState(() => _error = e.toString());
                        }
                        setState(() => _loading = false);
                      },
                child: const Text('Sign In'),
              ),
            ] else ...[
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone (e.g., +94123456789)'),
              ),
              const SizedBox(height: 8),
              if (_verificationId == null)
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            await auth.verifyPhone(_phoneController.text.trim(), (verificationId) {
                              setState(() {
                                _verificationId = verificationId;
                              });
                            }, (err) {
                              setState(() => _error = err.message);
                            });
                          } catch (e) {
                            setState(() => _error = e.toString());
                          }
                          setState(() => _loading = false);
                        },
                  child: const Text('Send OTP'),
                )
              else ...[
                TextField(
                  controller: _smsController,
                  decoration: const InputDecoration(labelText: 'SMS Code'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            await auth.signInWithSmsCode(_verificationId!, _smsController.text.trim());
                          } catch (e) {
                            setState(() => _error = e.toString());
                          }
                          setState(() => _loading = false);
                        },
                  child: const Text('Verify Code'),
                ),
              ]
            ,
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
