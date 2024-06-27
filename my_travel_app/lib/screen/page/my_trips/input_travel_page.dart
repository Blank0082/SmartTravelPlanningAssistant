import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers.dart';
import 'travel_plan_page.dart';

class InputTravelPage extends ConsumerStatefulWidget {
  const InputTravelPage({super.key});

  @override
  InputTravelPageState createState() => InputTravelPageState();
}

class InputTravelPageState extends ConsumerState<InputTravelPage> {
  final TextEditingController _locationController = TextEditingController();
  final List<String> _locations = [];

  Future<void> submitData() async {
    final budget = ref.read(budgetProvider);
    final travelDays = ref.read(travelDaysProvider);
    final numberOfPeople = ref.read(numberOfPeopleProvider);
    final selectedCountry = ref.read(selectedCountryProvider);

    final backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';
    final endpoint = '$backendApiUrl/api/generateTravelPlan';

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': ref.watch(usernameProvider),
          'budget': budget,
          'travelDays': travelDays,
          'numberOfPeople': numberOfPeople,
          'selectedCountry': selectedCountry,
          'customLocation': _locations,
        }),
      );
      if (!mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final travelPlan = jsonDecode(response.body);
        ref.read(showInputTravelPageProvider.notifier).state = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TravelPlanPage(
                      travelPlan: travelPlan,
                      showConfirmButton: true,
                      goBack: () {
                        Navigator.pop(context);
                      },
                    )));
      } else {
        _showErrorDialog('伺服器錯誤', '稍後重試');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      if (!mounted) return;
      Navigator.pop(context);
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

  void addLocation() {
    final text = _locationController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _locations.add(text);
        _locationController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('輸入旅行需求'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '預算 (TWD)',
                ),
                onChanged: (value) => ref.read(budgetProvider.notifier).state =
                    double.tryParse(value) ?? 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '旅行天數',
                ),
                onChanged: (value) => ref
                    .read(travelDaysProvider.notifier)
                    .state = int.tryParse(value) ?? 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '人數',
                ),
                onChanged: (value) => ref
                    .read(numberOfPeopleProvider.notifier)
                    .state = int.tryParse(value) ?? 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: ref.watch(selectedCountryProvider),
                onChanged: (newValue) =>
                    ref.read(selectedCountryProvider.notifier).state = newValue,
                items: <String>['美國', '加拿大', '日本', '南韓', '台灣']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: '選擇國家',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: '感興趣的地點（可選）',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: addLocation,
                  ),
                ],
              ),
            ),
            if (_locations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: _locations
                      .map((location) => Chip(
                            label: Text(location),
                            onDeleted: () {
                              setState(() {
                                _locations.remove(location);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(showInputTravelPageProvider.notifier).state =
                        false;
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    submitData();
                  },
                  child: const Text('送出'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
