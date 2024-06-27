import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('設置'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('語言'),
            onTap: () {
              // 語言設置的邏輯
            },
          ),
          ListTile(
            title: const Text('通知'),
            onTap: () {
              // 通知設置的邏輯
            },
          ),
          ListTile(
            title: const Text('提交反饋'),
            onTap: () {
              // 反饋提交的邏輯
            },
          ),
        ],
      ),
    );
  }
}
