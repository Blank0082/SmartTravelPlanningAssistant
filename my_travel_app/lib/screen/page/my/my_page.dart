import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers.dart';
import 'settings_page.dart';
import 'user_login_page.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<bool>(resetNotifierProvider, (_, __) {
      ref.read(showSettingsProvider.notifier).state = false;
    });

    final showSettings = ref.watch(showSettingsProvider);
    final username = ref.read(usernameProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('我的'),
        actions: [
          if (!showSettings)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () =>
                  ref.read(showSettingsProvider.notifier).state = true,
            ),
        ],
      ),
      body: showSettings
          ? const SettingsPage()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                  const SizedBox(height: 20),
                  if (username != null)
                    Text('歡迎, $username')
                  else
                    const Text('歡迎遊客'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (username != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        ref.read(usernameProvider.notifier).state = null;
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserLoginPage(
                                      showSkipButton: true)));
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UserLoginPage(showSkipButton: false)),
                        );
                      }
                    },
                    child: Text(username != null ? '登出' : '登錄'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      floatingActionButton: showSettings
          ? FloatingActionButton(
              onPressed: () =>
                  ref.read(showSettingsProvider.notifier).state = false,
              child: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }
}
