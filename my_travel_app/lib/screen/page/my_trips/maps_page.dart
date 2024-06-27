import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatelessWidget {
  final String location;

  const MapsPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地圖導航'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _getLatLng(location),
          zoom: 12.0,
        ),
      ),
    );
  }

  LatLng _getLatLng(String location) {
    // 這裡你需要一個方法來將位置轉換為LatLng
    // 這通常需要使用Geocoding API
    // 以下是一個假設的示例
    if (location == '某地點') {
      return const LatLng(37.77483, -122.41942); // 替換為實際經緯度
    }
    return const LatLng(0, 0); // 默認返回0,0
  }
}
