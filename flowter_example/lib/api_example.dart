import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flowter_core/services/api/api.dart';
import 'package:flowter_core/enums/http_request_type.dart';
import 'package:flowter_core/classes/exceptions.dart';

/// Example page demonstrating how to use the API class from flowter_core
class ApiExample extends StatefulWidget {
  const ApiExample({super.key});

  @override
  State<ApiExample> createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  ApiController? _api;
  bool _isInitialized = false;
  bool _isLoading = false;
  String _responseText = '';
  String _errorText = '';
  bool _hasConnectivity = false;

  // Configuration fields
  final TextEditingController _baseUrlController = TextEditingController(
    text: 'https://jsonplaceholder.typicode.com',
  );
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _pathController = TextEditingController(
    text: 'posts/1',
  );
  final TextEditingController _bodyController = TextEditingController(
    text:
        '{\n  "title": "Test Post",\n  "body": "This is a test",\n  "userId": 1\n}',
  );

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _tokenController.dispose();
    _pathController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final hasConnection = await ApiController.hasConnectivity();
    setState(() {
      _hasConnectivity = hasConnection;
    });
  }

  void _initializeApi() {
    try {
      _api = ApiController(
        baseURL: _baseUrlController.text.trim(),
        apiDefaultVersion: 1,
        getToken: _tokenController.text.trim().isEmpty
            ? null
            : () => _tokenController.text.trim(),
        getAcceptLanguage: () => 'en-US',
      );

      // Add request callback for logging
      _api!.addOnRequestCallback((path, type, headers, body) {
        if (mounted) {
          setState(() {
            _responseText = 'Request: ${type.name.toUpperCase()} $path\n';
            _responseText += 'Headers: ${headers.toString()}\n';
            if (body != null) {
              _responseText += 'Body: $body\n';
            }
          });
        }
      });

      // Add response callback for logging
      _api!.addOnResponseCallback((path, type, code, headers, body) {
        if (mounted) {
          setState(() {
            _responseText += '\nResponse Code: $code\n';
            _responseText += 'Response Headers: ${headers.toString()}\n';
          });
        }
      });

      setState(() {
        _isInitialized = true;
        _errorText = '';
        _responseText =
            'API initialized successfully!\nBase URL: ${_api!.baseURL}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorText = 'Error initializing API: $e';
      });
    }
  }

  Future<void> _makeRequest(HttpRequestType type) async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please initialize the API first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
      _responseText = 'Making ${type.name.toUpperCase()} request...\n';
    });

    try {
      dynamic body;
      if (type != HttpRequestType.get && type != HttpRequestType.delete) {
        try {
          body = json.decode(_bodyController.text);
        } catch (e) {
          setState(() {
            _errorText = 'Invalid JSON in body: $e';
            _isLoading = false;
          });
          return;
        }
      }

      final response = await _api!.request(
        type: type,
        path: _pathController.text.trim(),
        body: body,
        timeout: 30,
      );

      setState(() {
        _isLoading = false;
        _responseText += '\n✅ Success!\n';
        _responseText += 'Status Code: ${response.code}\n';
        _responseText += 'Response Data:\n${_formatJson(response.data)}';
      });
    } on NoConnectionException {
      setState(() {
        _isLoading = false;
        _errorText = 'No internet connection available';
      });
    } on NetworkException catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Network error: ${e.type}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'Error: $e';
      });
    }
  }

  String _formatJson(dynamic data) {
    if (data == null) return 'null';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connectivity Status
            Card(
              color:
                  _hasConnectivity ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      _hasConnectivity ? Icons.wifi : Icons.wifi_off,
                      color: _hasConnectivity ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasConnectivity
                          ? 'Connected to Internet'
                          : 'No Internet Connection',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _hasConnectivity ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _checkConnectivity,
                      tooltip: 'Check Connectivity',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // API Configuration Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Configuration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _baseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Base URL',
                        border: OutlineInputBorder(),
                        hintText: 'https://api.example.com',
                      ),
                      enabled: !_isInitialized,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Bearer Token (Optional)',
                        border: OutlineInputBorder(),
                        hintText: 'Leave empty if not needed',
                      ),
                      enabled: !_isInitialized,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isInitialized ? null : _initializeApi,
                      icon: Icon(
                          _isInitialized ? Icons.check_circle : Icons.settings),
                      label: Text(_isInitialized
                          ? 'API Initialized'
                          : 'Initialize API'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Request Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Make Request',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pathController,
                      decoration: const InputDecoration(
                        labelText: 'API Path',
                        border: OutlineInputBorder(),
                        hintText: 'posts/1',
                        helperText: 'Path relative to base URL (e.g., posts/1)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      decoration: const InputDecoration(
                        labelText: 'Request Body (JSON)',
                        border: OutlineInputBorder(),
                        helperText: 'Used for POST, PUT, PATCH requests',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _makeRequest(HttpRequestType.get),
                          icon: const Icon(Icons.download),
                          label: const Text('GET'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _makeRequest(HttpRequestType.post),
                          icon: const Icon(Icons.upload),
                          label: const Text('POST'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _makeRequest(HttpRequestType.put),
                          icon: const Icon(Icons.edit),
                          label: const Text('PUT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _makeRequest(HttpRequestType.patch),
                          icon: const Icon(Icons.update),
                          label: const Text('PATCH'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _makeRequest(HttpRequestType.delete),
                          icon: const Icon(Icons.delete),
                          label: const Text('DELETE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Response Section
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            if (_errorText.isNotEmpty)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),

            if (_responseText.isNotEmpty && !_isLoading)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Response',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: _responseText));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Copied to clipboard')),
                              );
                            },
                            tooltip: 'Copy Response',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _responseText,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'About This Example',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example demonstrates how to use the API class from flowter_core:\n'
                      '• Initialize API with base URL and optional token\n'
                      '• Make GET, POST, PUT, PATCH, DELETE requests\n'
                      '• Handle responses and errors\n'
                      '• Check connectivity status\n'
                      '• Use request/response callbacks\n\n'
                      'The default base URL points to JSONPlaceholder, a fake REST API for testing.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
