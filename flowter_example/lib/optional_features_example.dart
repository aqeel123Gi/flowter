import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

/// Example showing how to use optional Flowter features
class OptionalFeaturesExample extends StatefulWidget {
  const OptionalFeaturesExample({super.key});

  @override
  State<OptionalFeaturesExample> createState() =>
      _OptionalFeaturesExampleState();
}

class _OptionalFeaturesExampleState extends State<OptionalFeaturesExample> {
  String _status = 'Initializing...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeFeatures();
  }

  /// Initialize optional features if available
  Future<void> _initializeFeatures() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking available features...';
    });

    List<String> availableFeatures = [];
    List<String> unavailableFeatures = [];

    // Check Bluetooth availability
    try {
      // This will only work if flowter_io is available and Bluetooth is supported
      // await IOBluetooth.initialize();
      availableFeatures.add('Bluetooth I/O');
    } catch (e) {
      unavailableFeatures.add('Bluetooth I/O');
    }

    // Check NFC availability
    try {
      // This will only work if flowter_io is available and NFC is supported
      // await IONFC.initialize();
      availableFeatures.add('NFC I/O');
    } catch (e) {
      unavailableFeatures.add('NFC I/O');
    }

    // Check Serial availability
    try {
      // This will only work if flowter_io is available and Serial is supported
      // await IOSerial.initialize();
      availableFeatures.add('Serial I/O');
    } catch (e) {
      unavailableFeatures.add('Serial I/O');
    }

    setState(() {
      _isLoading = false;
      _status = 'Features checked successfully';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optional Features Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Optional Features Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Status Card
            Card(
              color: _isLoading ? Colors.blue.shade50 : Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _status,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Features List
            const Text(
              'Available Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildFeatureItem(
              title: 'Core Features',
              description: 'Widgets, Extensions, Controllers',
              isAvailable: true,
              icon: Icons.widgets,
              color: Colors.green,
            ),

            _buildFeatureItem(
              title: 'Bluetooth I/O',
              description: 'Bluetooth scanning and communication',
              isAvailable:
                  false, // This would be dynamic in real implementation
              icon: Icons.bluetooth,
              color: Colors.blue,
            ),

            _buildFeatureItem(
              title: 'NFC I/O',
              description: 'NFC reading and writing',
              isAvailable:
                  false, // This would be dynamic in real implementation
              icon: Icons.nfc,
              color: Colors.purple,
            ),

            _buildFeatureItem(
              title: 'Serial I/O',
              description: 'Serial port communication',
              isAvailable:
                  false, // This would be dynamic in real implementation
              icon: Icons.cable,
              color: Colors.orange,
            ),

            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _initializeFeatures,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'How to enable optional features:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Add flowter_io to pubspec.yaml\n'
                    '2. Import the package in your code\n'
                    '3. Check platform support\n'
                    '4. Initialize the features',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required String title,
    required String description,
    required bool isAvailable,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isAvailable ? color : Colors.grey,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isAvailable ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: isAvailable ? Colors.black87 : Colors.grey,
          ),
        ),
        trailing: Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: 24,
        ),
      ),
    );
  }
}
