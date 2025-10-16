import 'package:flowter_core/widgets/advance_text_editing/advance_text_field.dart';
import 'package:flowter_core/widgets/sd_icon/sd_icon.dart';
import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

/// Example showing AdvancedTextField widget usage
class AdvancedTextFieldExample extends StatefulWidget {
  const AdvancedTextFieldExample({super.key});

  @override
  State<AdvancedTextFieldExample> createState() => _AdvancedTextFieldExampleState();
}

class _AdvancedTextFieldExampleState extends State<AdvancedTextFieldExample> {
  // Controllers for different examples
  final AdvancedTextFieldController _basicController = AdvancedTextFieldController();
  final AdvancedTextFieldController _emailController = AdvancedTextFieldController();
  final AdvancedTextFieldController _passwordController = AdvancedTextFieldController();
  final AdvancedTextFieldController _phoneController = AdvancedTextFieldController();
  final AdvancedTextFieldController _multilineController = AdvancedTextFieldController();
  final AdvancedTextFieldController _customValidationController = AdvancedTextFieldController();

  // Form validation state
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    // Listen to all controllers for validation changes
    AdvancedTextFieldController.addListenerForList([
      _emailController,
      _passwordController,
      _phoneController,
      _customValidationController,
    ], _checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = AdvancedTextFieldController.allValidated([
        _emailController,
        _passwordController,
        _phoneController,
        _customValidationController,
      ]);
    });
  }

  @override
  void dispose() {
    _basicController.textEditing.dispose();
    _emailController.textEditing.dispose();
    _passwordController.textEditing.dispose();
    _phoneController.textEditing.dispose();
    _multilineController.textEditing.dispose();
    _customValidationController.textEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdvancedTextField Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AdvancedTextField Widget Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Basic Example
            _buildExampleCard(
              title: '1. Basic TextField',
              description: 'Simple text input with basic styling',
              child: AdvancedTextField(
                controller: _basicController,
                hintText: 'Enter your name',
                title: 'Name',
                height: 50,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
              ),
            ),

            const SizedBox(height: 20),

            // Email Validation Example
            _buildExampleCard(
              title: '2. Email Validation',
              description: 'Email input with validation',
              child: AdvancedTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                title: 'Email',
                height: 50,
                textInputType: TextInputType.emailAddress,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
                textValidations: [
                  TextValidation(
                    validate: (text) => text.isNotEmpty,
                    onNotValidatedMessage: (title) => 'Email is required',
                  ),
                  TextValidation(
                    validate: (text) => text.contains('@') && text.contains('.'),
                    onNotValidatedMessage: (title) => 'Please enter a valid email',
                  ),
                ],
                validateAfterChangeDuration: const Duration(milliseconds: 500),
              ),
            ),

            const SizedBox(height: 20),

            // Password Example
            _buildExampleCard(
              title: '3. Password Field',
              description: 'Password input with visibility toggle',
              child: AdvancedTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                title: 'Password',
                height: 50,
                obscure: true,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
                textValidations: [
                  TextValidation(
                    validate: (text) => text.length >= 6,
                    onNotValidatedMessage: (title) => 'Password must be at least 6 characters',
                  ),
                ],
                validateAfterChangeDuration: const Duration(milliseconds: 500),
              ),
            ),

            const SizedBox(height: 20),

            // Phone Number Example
            _buildExampleCard(
              title: '4. Phone Number with Custom Validation',
              description: 'Phone input with custom character restrictions',
              child: AdvancedTextField(
                controller: _phoneController,
                hintText: 'Enter phone number',
                title: 'Phone',
                height: 50,
                textInputType: TextInputType.phone,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
                allowedCharacters: const {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '(', ')', ' '},
                textValidations: [
                  TextValidation(
                    validate: (text) => text.length >= 10,
                    onNotValidatedMessage: (title) => 'Phone number must be at least 10 digits',
                  ),
                ],
                validateAfterChangeDuration: const Duration(milliseconds: 500),
              ),
            ),

            const SizedBox(height: 20),

            // Multiline Example
            _buildExampleCard(
              title: '5. Multiline Text Field',
              description: 'Text area for longer content',
              child: AdvancedTextField(
                controller: _multilineController,
                hintText: 'Enter your message...',
                title: 'Message',
                height: 120,
                lines: 4,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
                valueTextAlign: TextAlign.start,
                hintTextAlign: TextAlign.start,
              ),
            ),

            const SizedBox(height: 20),

            // Custom Validation Example
            _buildExampleCard(
              title: '6. Custom Validation with Future',
              description: 'Async validation example',
              child: AdvancedTextField(
                controller: _customValidationController,
                hintText: 'Enter username',
                title: 'Username',
                height: 50,
                textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintTextStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                decorationOnFocus: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                cursorColor: Colors.blue,
                nonValidatedTextMessageColor: Colors.red,
                waitingColor: Colors.blue,
                nonValidatedTextMessageFontSize: 12,
                nonValidatedTextMessageDirection: TextDirection.ltr,
                textDirection: TextDirection.ltr,
                obscureTextIcon: const SDIcon(iconData: Icons.visibility),
                noObscureTextIcon: const SDIcon(iconData: Icons.visibility_off),
                textValidations: [
                  TextValidation(
                    validate: (text) => text.length >= 3,
                    onNotValidatedMessage: (title) => 'Username must be at least 3 characters',
                  ),
                ],
                futureTextValidations: [
                  FutureTextValidation(
                    validate: (text) async {
                      // Simulate async validation (e.g., checking if username exists)
                      await Future.delayed(const Duration(seconds: 1));
                      return text != 'admin' && text != 'user';
                    },
                    onNotValidatedMessage: (title) => 'Username is already taken',
                  ),
                ],
                validateAfterChangeDuration: const Duration(milliseconds: 1000),
              ),
            ),

            const SizedBox(height: 30),

            // Form Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isFormValid ? _submitForm : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Submit Form'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAllFields,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear All'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Form Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isFormValid ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isFormValid ? Colors.green.shade200 : Colors.orange.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isFormValid ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isFormValid 
                        ? 'All fields are valid and ready to submit!'
                        : 'Please fill in all required fields correctly.',
                    style: TextStyle(
                      color: _isFormValid ? Colors.green.shade600 : Colors.orange.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Code Example
            _buildCodeExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Code Example',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                '''// Basic AdvancedTextField usage
AdvancedTextField(
  controller: controller,
  hintText: 'Enter text',
  title: 'Field Title',
  height: 50,
  textStyle: TextStyle(fontSize: 16),
  hintTextStyle: TextStyle(fontSize: 16, color: Colors.grey),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  decorationOnFocus: BoxDecoration(
    border: Border.all(color: Colors.blue),
    borderRadius: BorderRadius.circular(8),
  ),
  cursorColor: Colors.blue,
  nonValidatedTextMessageColor: Colors.red,
  waitingColor: Colors.blue,
  nonValidatedTextMessageFontSize: 12,
  nonValidatedTextMessageDirection: TextDirection.ltr,
  textDirection: TextDirection.ltr,
  obscureTextIcon: SDIcon(Icons.visibility),
  noObscureTextIcon: SDIcon(Icons.visibility_off),
  textValidations: [
    TextValidation(
      validate: (text) => text.isNotEmpty,
      onNotValidatedMessage: (title) => 'Field is required',
    ),
  ],
)''',
                style: TextStyle(
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

  void _submitForm() {
    if (_isFormValid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${_basicController.textEditing.text}'),
              Text('Email: ${_emailController.textEditing.text}'),
              Text('Phone: ${_phoneController.textEditing.text}'),
              Text('Username: ${_customValidationController.textEditing.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _clearAllFields() {
    _basicController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _multilineController.clear();
    _customValidationController.clear();
    setState(() {
      _isFormValid = false;
    });
  }
}
