import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accounting/features/auth/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录/注册')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '用户名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
              ),
              if (!_isLogin) // 仅在注册时显示邮箱字段
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '邮箱'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    return null;
                  },
                ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '密码'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final authService = ref.read(authServiceProvider);
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    bool success;
                    if (_isLogin) {
                      success = await authService.login(
                        username,
                        password,
                        context,
                      );
                    } else {
                      final email = _emailController.text;
                      success = await authService.register(
                        username,
                        email,
                        password,
                        context,
                      );
                    }

                    if (success && mounted) {
                      // 注册成功后，跳转至登录界面
                      if (!_isLogin) {
                        setState(() {
                          _isLogin = true; // 切换到登录界面
                        });
                      }
                    }
                  }
                },
                child: Text(_isLogin ? '登录' : '注册'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? '没有账号？注册' : '已有账号？登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}