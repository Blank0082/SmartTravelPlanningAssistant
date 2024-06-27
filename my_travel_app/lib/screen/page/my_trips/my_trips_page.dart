import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers.dart';
import '../my/user_login_page.dart';
import 'input_travel_page.dart';

class MyTripsPage extends ConsumerStatefulWidget {
  final Function(dynamic plan) showTravelPlan;

  const MyTripsPage({super.key, required this.showTravelPlan});

  @override
  MyTripsPageState createState() => MyTripsPageState();
}

class MyTripsPageState extends ConsumerState<MyTripsPage> {
  List<dynamic> _travelPlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTravelPlans();
  }

  Future<void> _fetchTravelPlans() async {
    final backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username != null) {
      final endpoint = '$backendApiUrl/api/getTravelPlans?username=$username';

      try {
        final response = await http.get(Uri.parse(endpoint));

        if (response.statusCode == 200) {
          setState(() {
            _travelPlans = jsonDecode(response.body);
            _isLoading = false;
          });
        } else {
          _travelPlans = [];
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (kDebugMode) {
          print('Error fetching travel plans: $e');
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('需要登入'),
          content: const Text('請先登入以建立新行程。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(showInputTravelPageProvider.notifier).state = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const UserLoginPage(showSkipButton: false)),
                );
              },
              child: const Text('登入'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showInputPage = ref.watch(showInputTravelPageProvider);
    final username = ref.watch(usernameProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('我的行程'),
        centerTitle: true,
      ),
      body: showInputPage
          ? const InputTravelPage()
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _travelPlans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('當前無行程，開始規劃您的旅行吧！'),
                          ElevatedButton(
                            onPressed: () {
                              if (username != null) {
                                ref
                                    .read(showInputTravelPageProvider.notifier)
                                    .state = true;
                              } else {
                                _showLoginDialog(context);
                              }
                            },
                            child: const Text('建立新行程'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _travelPlans.length,
                      itemBuilder: (context, index) {
                        final plan = _travelPlans[index];
                        final travelSuggestions = plan['travelSuggestions'];

                        return ListTile(
                          title: Text('行程 ${index + 1}'),
                          subtitle: Text(
                            travelSuggestions,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            widget.showTravelPlan(plan);
                          },
                        );
                      },
                    ),
      floatingActionButton: showInputPage ||
              username == null ||
              _travelPlans.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(showInputTravelPageProvider.notifier).state = true,
              label: const Text('新增新行程'),
              icon: const Icon(Icons.add),
            ),
    );
  }
}
