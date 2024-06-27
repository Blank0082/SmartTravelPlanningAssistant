import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../main_screen.dart';

class TravelPlanPage extends ConsumerWidget {
  final Map<String, dynamic> travelPlan;
  final VoidCallback? goBack;
  final bool showConfirmButton;

  const TravelPlanPage({
    super.key,
    required this.travelPlan,
    this.goBack,
    this.showConfirmButton = false,
  });

  Future<void> _openGoogleMaps(String destination) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destination');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteTravelPlan(BuildContext context, WidgetRef ref) async {
    final backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';
    final endpoint = '$backendApiUrl/api/deleteTravelPlan';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          '_id': travelPlan['_id'],
        }),
      );

      if (response.statusCode == 200) {
        if (goBack != null) {
          goBack!();
        }
      } else {
        if (context.mounted) {
          _showErrorDialog(context, '伺服器錯誤', '稍後重試');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      if (context.mounted) {
        _showErrorDialog(context, '伺服器錯誤', '稍後重試');
      }
    }
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認刪除'),
          content: const Text('您確定要刪除此旅行計劃嗎？此操作無法撤銷。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTravelPlan(context, ref);
              },
              child: const Text('刪除'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelSuggestions = travelPlan['travelSuggestions'];
    final days = travelPlan['travelPlan']['days'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('旅行計劃'),
        leading: goBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  goBack!();
                },
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '旅行建議',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                travelSuggestions,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '每天的旅行計劃',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final dayPlan = days[index];
                  final day = dayPlan['day'];
                  final activities = dayPlan['activities'] as List<dynamic>;
                  final destinations = dayPlan['destinations'] as List<dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '第$day天',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '活動：',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...activities.map((activity) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(activity),
                              )),
                          const SizedBox(height: 10),
                          const Text(
                            '目的地：',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...destinations.map((destination) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: InkWell(
                                  onTap: () => _openGoogleMaps(destination),
                                  child: Text(
                                    destination,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showConfirmButton
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MainScreen(selectedIndex: 1)));
              },
              label: const Text('確認'),
              icon: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
