import 'package:flutter/material.dart';
import 'package:test_drive/viewreport_page.dart';
import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CameraPage(), // Navigate to the camera page
                  ),
                );
              },
              child: const Text('Scan Food'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewReportPage(), // Navigate to the camera page
                  ),
                );
              },
              child: const Text('View Report'),
            ),
          ],
        ),
        // Add the bottom navigation bar
      ),
    );
  }
}
