library dev_stage;

import 'package:flutter/material.dart';
import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/io/memory/memory.dart';

part '_dev_stage.dart';
part '_dev_stage_builder.dart';

class DevStageController {

  static bool get initialized => _initialized;
  static bool _initialized = false;
  static late Map<DevStage,Color> colors;
  static late DevStage stage;

  static Future<void> initialize({
    Color proColor = Colors.green,
    Color stgColor = Colors.blue,
    Color devColor = Colors.yellow,
  })async{
    DevStageController.colors = <DevStage,Color>{
      DevStage.production: proColor,
      DevStage.staging: stgColor,
      DevStage.development: devColor
    };
    String stageName = await Memory.get('.settings', 'dev_stage', 'production');
    stage = DevStage.values.singleWhere((value)=> value.name == stageName);
    _initialized = true;
  }


  static Future<void> setStage(DevStage stage)async{
    await Memory.save('.settings', 'dev_stage', stage.name);
    DevStageController.stage = stage;
  }


}