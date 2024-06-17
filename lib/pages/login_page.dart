import 'package:flutter/material.dart';
import 'package:remych_chat/pages/chat_page.dart';
import 'package:remych_chat/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() {
    setState(() {
      _isLoading = true;
    });

    supabase.auth
        .signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((_) => {
              Navigator.of(context)
                  .pushAndRemoveUntil(ChatPage.route(), (route) => false)
            })
        .catchError((error) {
      if (error is AuthException) {
        context.showErrorSnackBar(message: error.message);
      } else {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
    });

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: formPadding,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          formSpacer,
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          formSpacer,
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
