import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/my/my_page.dart';
import 'page/my_trips/my_trips_page.dart';
import 'page/my_trips/travel_plan_page.dart';
import 'page/search_page.dart';
import 'providers.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int selectedIndex;

  const MainScreen({super.key, this.selectedIndex = 1});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  int _selectedIndex = 1;
  dynamic _selectedPlan;

  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? user = prefs.getString('username');

    if (user != null) {
      ref.read(usernameProvider.notifier).state = user;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedPlan = null;
    });
    if (index == 2) {
      ref.read(resetNotifierProvider.notifier).state =
          !ref.read(resetNotifierProvider.notifier).state;
    }
  }

  void _showTravelPlan(dynamic plan) {
    setState(() {
      _selectedPlan = plan;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const SearchPage(),
      _selectedPlan == null
          ? MyTripsPage(showTravelPlan: _showTravelPlan)
          : TravelPlanPage(
              travelPlan: _selectedPlan,
              goBack: () {
                setState(() {
                  _selectedPlan = null;
                });
              },
              showConfirmButton: false),
      const MyPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: '我的行程',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
