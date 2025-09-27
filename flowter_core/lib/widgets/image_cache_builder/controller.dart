import 'dart:typed_data';
import 'package:flowter_core/flowter_core.dart';

import '../../controllers/bytes_cache/bytes_cache.dart';

class ImageCacheController extends WidgetController<ImageCacheBuilder> {
  late Future<Uint8List>? data;

  Future<Uint8List>? fetchData() =>
      widget.uri != null ? BytesCache.getAsImage(widget.uri!) : null;

  @override
  void onInit() {
    data = fetchData();
    _currentUri = widget.uri;
  }

  late String? _currentUri;

  @override
  void onStateStartUpdating() {
    if (_currentUri != widget.uri) {
      _currentUri = widget.uri;
      if (_currentUri == null) return;
      data = fetchData();
    }
  }
}
