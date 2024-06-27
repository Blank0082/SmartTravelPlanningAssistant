import 'package:flutter/material.dart';

class TravelPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Plan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Replace with your custom widgets and designs
            // Example: Header section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                // Add more decoration properties as needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your Trip Summary',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Add more Text Widgets or other Widgets as per your design
                ],
              ),
            ),
            // Example: List of travel locations
            // You can create a ListView.builder for a dynamic list
          ],
        ),
      ),
    );
  }
}
