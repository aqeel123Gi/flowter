// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../../../instructions.dart';
//
// class InstructionData{
//   InstructionData({
//     required this.id,
//     required this.widgetKeys,
//     required this.bordersExpands,
//     required this.statement,
//     required this.bordersRadius,
//     required this.bordersWidth,
//     required this.color,
//     this.processOnShow,
//   });
//
//   AppInstructionKey id;
//   List<GlobalKey> widgetKeys;
//   List<double> bordersExpands;
//   List<double> bordersRadius;
//   String statement;
//   double bordersWidth;
//   Color color;
//   void Function()? processOnShow;
// }
//
// class Instruction{
//
//
//   Instruction(this.id);
//
//   AppInstructionKey id;
//
//   static final Map<AppInstructionKey,InstructionData> instructions = {};
//
//   static Instruction add_mod_del({
//     required AppInstructionKey id,
//     required List<GlobalKey> widgetKeys,
//     required List<double> bordersExpands,
//     required List<double> bordersRadius,
//     required String statement,
//     void Function()? processOnShow,
//     Color color = Colors.orangeAccent,
//     double bordersWidth = 3
//   }){
//     instructions[id] = InstructionData(
//         id: id,
//         widgetKeys: widgetKeys,
//         bordersExpands: bordersExpands,
//         bordersRadius: bordersRadius,
//         statement: statement,
//         bordersWidth: bordersWidth,
//         color: color,
//         processOnShow: processOnShow
//     );
//     return Instruction(id);
//   }
//
//   static void showInstruction(BuildContext context, AppInstructionKey id)async{
//
//     // if(!(await Hive.openBox('default')).containsKey("Instruction:$id")){
//     //   showTransparentPage(context, InstructionWidget(data: Instruction.instructions[id]!),routeName: "Instruction:$id",back: false);
//     // }
//
//   }
//
//   static void showInstructionsGroup(BuildContext context, List<AppInstructionKey> idsList)async{
//
//     // if(!(await Hive.openBox('default')).containsKey("Instruction:${idsList.first}") && instructions[idsList.first]!.widgetKeys[0].currentWidget!=null){
//     //   showTransparentPage(context, InstructionWidget(
//     //     data: Instruction.instructions[idsList.first]!,
//     //     nextIds: idsList.length<=1?null:idsList.sublist(1),
//     //     parentScale: GlobalScaling.currentScale,
//     //   ),routeName: "Instruction:${idsList.first}",back: false);
//     // }
//     // else if(idsList.length>1){
//     //   showInstructionsGroup(context, idsList.sublist(1));
//     // }
//
//   }
//
//   static Future<void> repeatShownInstructions()async{
//     Box box = await Hive.openBox('default');
//     for(var key in box.keys) {
//       if(key.contains("Instruction:")){
//         await box.delete(key);
//       }
//     }
//   }
//
//   void show(BuildContext context){
//     return;
//     //showInstruction(context,id);
//   }
// }
//
