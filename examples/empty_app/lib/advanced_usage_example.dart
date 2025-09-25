import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

/// Example showing advanced Flowter usage patterns
class AdvancedUsageExample extends StatefulWidget {
  const AdvancedUsageExample({super.key});

  @override
  State<AdvancedUsageExample> createState() => _AdvancedUsageExampleState();
}

class _AdvancedUsageExampleState extends State<AdvancedUsageExample> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Usage Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildBasicUsagePage(),
          _buildOptionalFeaturesPage(),
          _buildPlatformSpecificPage(),
          _buildBestPracticesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Optional',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Platform',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Best Practices',
          ),
        ],
      ),
    );
  }

  Widget _buildBasicUsagePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Flowter Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildCodeExample(
            title: '1. Basic Import',
            code: '''
import 'package:flowter/flowter.dart';

void main() {
  runApp(MyApp());
}''',
          ),
          _buildCodeExample(
            title: '2. Using Core Features',
            code: '''
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello Flowter!'),
    );
  }
}''',
          ),
          _buildCodeExample(
            title: '3. Using Extensions',
            code: '''
// String extensions
String text = 'Hello World';
String capitalized = text.capitalize();

// List extensions
List<int> numbers = [1, 2, 3, 4, 5];
List<int> evenNumbers = numbers.where((n) => n % 2 == 0).toList();''',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalFeaturesPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Optional Features Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildCodeExample(
            title: '1. Adding Optional Dependencies',
            code: '''
# pubspec.yaml
dependencies:
  flowter:
    path: ../../
  flowter_io:
    path: ../../flowter_io
    optional: true''',
          ),
          _buildCodeExample(
            title: '2. Conditional Imports',
            code: '''
import 'package:flowter/flowter.dart';

// Conditional import for I/O features
import 'package:flowter_io/flowter_io.dart' 
  if (dart.library.io) 'package:flowter_io/flowter_io.dart';''',
          ),
          _buildCodeExample(
            title: '3. Feature Detection',
            code: '''
Future<void> initializeFeatures() async {
  try {
    // Try to initialize Bluetooth
    await IOBluetooth.initialize();
    print('Bluetooth available');
  } catch (e) {
    print('Bluetooth not available: \$e');
  }
}''',
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformSpecificPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform-Specific Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildCodeExample(
            title: '1. Platform Detection',
            code: '''
import 'dart:io';

bool get isBluetoothSupported {
  return Platform.isAndroid || 
         Platform.isIOS || 
         Platform.isMacOS || 
         Platform.isWindows;
}''',
          ),
          _buildCodeExample(
            title: '2. Platform-Specific Features',
            code: '''
Future<void> initializePlatformFeatures() async {
  if (Platform.isAndroid || Platform.isIOS) {
    // Mobile-specific features
    await initializeMobileFeatures();
  } else if (Platform.isWindows) {
    // Windows-specific features
    await initializeWindowsFeatures();
  }
}''',
          ),
          _buildCodeExample(
            title: '3. Conditional Widgets',
            code: '''
Widget buildPlatformSpecificWidget() {
  if (Platform.isAndroid || Platform.isIOS) {
    return MobileWidget();
  } else {
    return DesktopWidget();
  }
}''',
          ),
        ],
      ),
    );
  }

  Widget _buildBestPracticesPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Practices',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildBestPracticeItem(
            title: '1. Use Optional Dependencies',
            description: 'Only include features you actually need',
            code: '''
# Good: Only include what you need
dependencies:
  flowter:
    path: ../../
  flowter_io:
    path: ../../flowter_io
    optional: true''',
          ),
          _buildBestPracticeItem(
            title: '2. Handle Feature Availability',
            description: 'Always check if features are available',
            code: '''
Future<void> useFeature() async {
  try {
    await IOBluetooth.initialize();
    // Use Bluetooth feature
  } catch (e) {
    // Handle gracefully
    print('Feature not available');
  }
}''',
          ),
          _buildBestPracticeItem(
            title: '3. Platform-Specific Code',
            description: 'Use platform detection for better UX',
            code: '''
Widget buildApp() {
  return MaterialApp(
    home: Platform.isAndroid || Platform.isIOS 
      ? MobileHomePage()
      : DesktopHomePage(),
  );
}''',
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample({
    required String title,
    required String code,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPracticeItem({
    required String title,
    required String description,
    required String code,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
