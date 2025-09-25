import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

/// Demo class showing how to use Flowter features
class FeaturesDemo extends StatefulWidget {
  const FeaturesDemo({super.key});

  @override
  State<FeaturesDemo> createState() => _FeaturesDemoState();
}

class _FeaturesDemoState extends State<FeaturesDemo> {
  bool _bluetoothAvailable = false;
  bool _nfcAvailable = false;
  bool _serialAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkAvailableFeatures();
  }

  /// Check which Flowter features are available
  Future<void> _checkAvailableFeatures() async {
    setState(() {
      _bluetoothAvailable = false;
      _nfcAvailable = false;
      _serialAvailable = false;
    });

    // Check Bluetooth availability
    try {
      // This will only work if flowter_io is available
      // await IOBluetooth.initialize();
      _bluetoothAvailable = true;
    } catch (e) {
      _bluetoothAvailable = false;
    }

    // Check NFC availability
    try {
      // This will only work if flowter_io is available
      // await IONFC.initialize();
      _nfcAvailable = true;
    } catch (e) {
      _nfcAvailable = false;
    }

    // Check Serial availability
    try {
      // This will only work if flowter_io is available
      // await IOSerial.initialize();
      _serialAvailable = true;
    } catch (e) {
      _serialAvailable = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flowter Features Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Flowter Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Core Features (Always Available)
            _buildFeatureCard(
              title: 'Core Features',
              description: 'Widgets, Extensions, Controllers, Services',
              isAvailable: true,
              icon: Icons.widgets,
              color: Colors.green,
            ),

            const SizedBox(height: 16),

            // Bluetooth Features
            _buildFeatureCard(
              title: 'Bluetooth I/O',
              description: 'Bluetooth scanning, connection, and communication',
              isAvailable: _bluetoothAvailable,
              icon: Icons.bluetooth,
              color: _bluetoothAvailable ? Colors.blue : Colors.grey,
            ),

            const SizedBox(height: 16),

            // NFC Features
            _buildFeatureCard(
              title: 'NFC I/O',
              description: 'NFC reading and writing capabilities',
              isAvailable: _nfcAvailable,
              icon: Icons.nfc,
              color: _nfcAvailable ? Colors.purple : Colors.grey,
            ),

            const SizedBox(height: 16),

            // Serial Features
            _buildFeatureCard(
              title: 'Serial I/O',
              description: 'Serial port communication',
              isAvailable: _serialAvailable,
              icon: Icons.cable,
              color: _serialAvailable ? Colors.orange : Colors.grey,
            ),

            const SizedBox(height: 30),

            // Refresh Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _checkAvailableFeatures,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Features'),
              ),
            ),

            const SizedBox(height: 20),

            // Info Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'I/O features (Bluetooth, NFC, Serial) are optional and only available when flowter_io package is included.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required bool isAvailable,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isAvailable ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable ? Colors.green : Colors.red,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
