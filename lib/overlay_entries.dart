import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String,OverlayEntry> _overlayEntries = {};

removeOverlayEntry(String id){
  if(_overlayEntries.containsKey(id)){
    OverlayEntry? entry = _overlayEntries.remove(id);
    entry?.remove();
  }
}

showOverlayEntry(BuildContext context, String id, Widget widget){
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry entry = OverlayEntry(builder: (context) => widget);
  overlayState.insert(entry);
  _overlayEntries[id] = entry;
  return entry;
}