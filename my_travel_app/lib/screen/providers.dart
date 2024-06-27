import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetProvider = StateProvider<double>((ref) => 0);
final travelDaysProvider = StateProvider<int>((ref) => 1);
final numberOfPeopleProvider = StateProvider<int>((ref) => 1);
final selectedCountryProvider = StateProvider<String?>((ref) => null);
final customLocationProvider = StateProvider<String?>((ref) => '');
final showInputTravelPageProvider = StateProvider<bool>((ref) => false);
//my providers
final showSettingsProvider = StateProvider<bool>((ref) => false);
final resetNotifierProvider = StateProvider<bool>((ref) => false);

final usernameProvider = StateProvider<String?>((ref) => null);
