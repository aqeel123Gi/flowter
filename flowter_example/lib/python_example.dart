import 'package:flowter_python/flowter_python.dart';
import 'package:flutter/material.dart';

class PythonExample extends StatefulWidget {
  const PythonExample({super.key});

  @override
  State<PythonExample> createState() => _PythonExampleState();
}

class _PythonExampleState extends State<PythonExample> {
  
  TextEditingController _packageNameController = TextEditingController();

  bool _initialized = false;

  Future<void> _initialize() async {
    await FlowterPython.initialize();
    setState(() {
      _initialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Builder(builder: (context) {
          if (!_initialized) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              Text('Python Example'),
              TextField(
                controller: _packageNameController,
              ),
              ElevatedButton(
                onPressed: () =>
                    _installPackage(_packageNameController.text.trim()),
                child: Text('Install Package'),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _installPackage(String packageName) async {
    await FlowterPython.installPackage(packageName);
  }
}
