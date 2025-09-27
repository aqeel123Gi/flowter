import 'package:flutter/cupertino.dart';

void addPostFrameCallback(void Function() process){
  WidgetsBinding.instance.addPostFrameCallback((_) {
    process();
  });
}