# Flowter Empty Example

This is a basic example project demonstrating how to use the Flowter framework with optional features.

## 🚀 Features

- **Basic Flutter app structure** - Clean and minimal setup
- **Flowter core package integration** - Essential widgets and utilities
- **Optional I/O features** - Bluetooth, NFC, Serial communication
- **Optional advanced features** - Advanced widgets and controllers
- **Feature detection** - Shows which features are available
- **Responsive design** - Works on all screen sizes

## 📁 Project Structure

```
empty_app/
├── lib/
│   ├── main.dart              # Main app file
│   └── features_demo.dart     # Features demonstration
├── pubspec.yaml              # Dependencies configuration
├── analysis_options.yaml     # Linting configuration
├── .gitignore               # Git ignore rules
└── README.md                # This file
```

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (>=1.17.0)
- Dart SDK (^3.5.3)

### Installation

1. **Navigate to the example directory:**
   ```bash
   cd examples/empty_app
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Platform Support

- ✅ **Android** - Full support
- ✅ **iOS** - Full support  
- ✅ **Windows** - Full support
- ✅ **macOS** - Full support
- ✅ **Linux** - Full support
- ✅ **Web** - Core features only

## 📦 Dependencies

### Required
- **flowter**: Core Flowter framework (always included)

### Optional
- **flowter_io**: I/O capabilities (Bluetooth, NFC, Serial)
- **flowter_advanced**: Advanced features and widgets

## 🎯 Usage Examples

### Basic Usage
```dart
import 'package:flowter/flowter.dart';

void main() {
  runApp(MyApp());
}
```

### With Optional Features
```dart
import 'package:flowter/flowter.dart';
import 'package:flowter_io/flowter_io.dart'; // Optional

void main() {
  runApp(MyApp());
}
```

### Feature Detection
```dart
// Check if I/O features are available
try {
  await IOBluetooth.initialize();
  // Bluetooth is available
} catch (e) {
  // Bluetooth not available
}
```

## 🔧 Configuration

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Core Flowter package
  flowter:
    path: ../../
  
  # Optional I/O features
  flowter_io:
    path: ../../flowter_io
    optional: true
  
  # Optional advanced features
  flowter_advanced:
    path: ../../flowter_advanced
    optional: true
```

## 🎨 Features Demo

The app includes a features demonstration screen that shows:
- ✅ **Core Features** - Always available
- 🔵 **Bluetooth I/O** - Optional, platform-dependent
- 🟣 **NFC I/O** - Optional, platform-dependent
- 🟠 **Serial I/O** - Optional, platform-dependent

## 🚀 Next Steps

You can extend this example by:

### Adding I/O Features
```dart
// Bluetooth scanning
await IOBluetooth.scan(seconds: 5);

// NFC reading
await IONFC.read();

// Serial communication
await IOSerial.connect();
```

### Using Advanced Widgets
```dart
// Advanced Flowter widgets
AdvancedButton(
  onPressed: () {},
  child: Text('Advanced Button'),
)
```

### Custom Controllers
```dart
// Custom Flowter controllers
class MyController extends FlowterController {
  // Your custom logic
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Dependencies not found:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Optional features not working:**
   - Check if the feature is supported on your platform
   - Ensure the optional package is included in pubspec.yaml

3. **Build errors:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📚 Documentation

- [Flowter Core Documentation](../../README.md)
- [Flowter I/O Documentation](../../flowter_io/README.md)
- [Flowter Advanced Documentation](../../flowter_advanced/README.md)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.
