import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/brightness_mode/brightness_mode.dart';

class PreferredScreen extends StatelessWidget {
  const PreferredScreen({
    super.key,
    required this.content,

  });

  final Widget content;

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,overlays: SystemUiOverlay.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarContrastEnforced: false,
        statusBarBrightness: null,
        statusBarIconBrightness: BrightnessController.reversed(context),
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: BrightnessController.reversed(context),
    ),
    child:content);
  }
}
