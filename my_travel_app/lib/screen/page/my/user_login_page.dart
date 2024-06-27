import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main_screen.dart';
import '../../providers.dart';

class UserLoginPage extends ConsumerStatefulWidget {
  final bool showSkipButton;

  const UserLoginPage({super.key, this.showSkipButton = true});

  @override
  UserLoginPageState createState() => UserLoginPageState();
}

class UserLoginPageState extends ConsumerState<UserLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegistering = false;
  String? _errorMessage;

  Future<void> _submitAuth() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';

    final endpoint = _isRegistering
        ? '$backendApiUrl/api/register'
        : '$backendApiUrl/api/login';

    setState(() {
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        ref.read(usernameProvider.notifier).state = userData['username'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', userData['username']);

        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen(selectedIndex: 2)));
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = '用戶名已存在';
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = '帳號/密碼錯誤';
        });
      } else {
        _showErrorDialog('伺服器錯誤', '稍後重試');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      _showErrorDialog('伺服器錯誤', '稍後重試');
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('確認'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _skipAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? '註冊' : '登錄'),
        actions: [
          if (widget.showSkipButton)
            TextButton(
              onPressed: _skipAuth,
              child: const Text('暫時跳過', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: '用戶名'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '密碼'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAuth,
              child: Text(_isRegistering ? '註冊' : '登錄'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            Text(_isRegistering ? '已有帳號？' : '沒有帳號？'),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering ? '登錄' : '註冊'),
            ),
          ],
        ),
      ),
    );
  }
}
