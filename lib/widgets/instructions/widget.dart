// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:tahdir/assets/animated_transform.dart';
// import 'package:tahdir/assets/edges_coordinates.dart';
// import 'package:flowter/flowter.dart';
// import 'package:tahdir/assets/window_size.dart';
// import 'package:tahdir/custom/styles/values.dart';
// import '../../../instructions.dart';
// import '../../_controller.dart';
// import '../../functions/loop.dart';
// import '../animate/animate.dart';
// import 'new.dart';
//
// class InstructionWidget extends StatefulWidget {
//
//   const InstructionWidget({
//     super.key,
//     required this.data,
//     this.nextIds,
//     this.parentScale = 1,
//   });
//
//
//   final InstructionData data;
//   final List<AppInstructionKey>? nextIds;
//   final double parentScale;
//
//
//   @override
//   State<InstructionWidget> createState() => _InstructionWidgetState();
// }
//
// class _InstructionWidgetState extends State<InstructionWidget>{
//
//
//   // late Future<dynamic> _blankTouchDialogWithoutPop;
//   List<EdgesCoordinates> _edges = [];
//
//   late EdgesCoordinates bordersAreaEdges;
//
//   double _opacity = 0.0;
//   bool _hidden = true;
//   final int _ms = 400;
//
//   _hide()async{
//
//     setState(() {
//       _hidden = true;
//     });
//
//     await Future.delayed(Duration(milliseconds: _ms),(){
//
//       bool popped = false;
//       loopExecution(function: ()async{
//         if(ModalRoute.of(context)!.settings.name=="Instruction:${widget.data.id}"){
//           Navigator.pop(context);
//           popped = true;
//         }
//       },
//           breakDuration: const Duration(milliseconds: 500),
//           stopOn: ()=>popped);
//
//       if(widget.nextIds!=null){
//         // Instruction.showInstructionsGroup(context,widget.nextIds!);
//       }
//     });
//
//   }
//
//   _animation()async{
//     await Future.delayed(const Duration(milliseconds: 200));
//     AnimateController.showByID("Instruction:<column>");
//     await Future.delayed(const Duration(milliseconds: 200));
//     AnimateController.showByID("Instruction:<statement>");
//     await Future.delayed(const Duration(milliseconds: 200));
//     AnimateController.showByID("Instruction:<hide>");
//   }
//
//
//   _updateEdges(){
//
//     _edges = [];
//
//     bordersAreaEdges = EdgesCoordinates(top: 9999, bottom: -9999, left: 9999, right: -9999);
//
//     widget.data.widgetKeys.forIndexedEach((i,e) {
//
//       EdgesCoordinates edges = getEdgesFromKey(e,edgesExpand: widget.data.bordersExpands[i],modifyPositionScalingByParentScale: widget.parentScale)!;
//       _edges.add_mod_del(edges);
//
//       if(bordersAreaEdges.top>edges.top){
//         bordersAreaEdges.top=edges.top;
//       }
//
//       if(bordersAreaEdges.bottom<edges.bottom){
//         bordersAreaEdges.bottom=edges.bottom;
//       }
//
//       if(bordersAreaEdges.left>edges.left){
//         bordersAreaEdges.left=edges.left;
//       }
//
//       if(bordersAreaEdges.right<edges.right){
//         bordersAreaEdges.right=edges.right;
//       }
//
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _updateEdges();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         _hidden = false;
//       });
//       _animation();
//       loopExecution(
//           function: ()async{
//             if(mounted){
//               setState(() {
//                 _opacity = _opacity==0?1:0;
//               });
//             }
//           },
//           breakDuration: Duration(milliseconds: _ms),
//           stopOn: ()=>!mounted
//       );
//
//       loopExecution(
//           function: ()async{
//             _updateEdges();
//           },
//           breakDuration: const Duration(milliseconds: 100),
//           stopOn: ()=>!mounted
//       );
//
//     });
//     if(widget.data.processOnShow!=null){
//       widget.data.processOnShow!();
//     }
//   }
//
//   double? _getStatementLeft(EdgesCoordinates edges){
//     double left = edges.left+((edges.right-edges.left)*0.5)-120;
//     if(left<AppScale.frontCardPadding()){
//       return AppScale.frontCardPadding();
//     }else if (left+240>Window.width(context)-AppScale.frontCardPadding()){
//       return Window.width(context)-AppScale.frontCardPadding()-240;
//     }else{
//       return left;
//     }
//   }
//
//   double? _getStatementTop(EdgesCoordinates edges){
//
//     double up = edges.top;
//     double bottom = Window.height(context)-edges.bottom;
//
//     if(up<=bottom){
//       return edges.bottom+20;
//     }else{
//       return null;
//     }
//
//   }
//
//   double? _getStatementBottom(EdgesCoordinates edges){
//
//     double up = edges.top;
//     double bottom = Window.height(context)-edges.bottom;
//
//     if(up>bottom){
//       return (Window.height(context)-edges.top)+20;
//     }else{
//       return null;
//     }
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return AnimatedOpacity(
//         opacity: _hidden?0.0:1.0,
//         duration: Duration(milliseconds: _ms),
//     curve: Curves.easeInOutQuad,
//     child:Stack(children: [
//       Container(color: Colors.black.withValues(alpha:0.05)),
//       Stack(children:List.generate(_edges.length, (index) => AnimatedPositioned(
//         curve: Curves.easeInOut,
//         duration: const Duration(milliseconds: 500),
//           top:_edges[index].top,
//           left:_edges[index].left,
//           child:AnimatedOpacity(
//               opacity: _opacity,
//               duration: Duration(milliseconds: _ms),
//               curve: Curves.easeInOutQuad,
//               child:Container(
//                 height: _edges[index].bottom-_edges[index].top,
//                 width: _edges[index].right-_edges[index].left,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(widget.data.bordersRadius[index]),
//                   border: Border.all(width: widget.data.bordersWidth,color: widget.data.color),
//                 ),
//               ))))
//         ),
//         AnimatedPositioned(
//             curve: Curves.easeInOut,
//             duration: const Duration(milliseconds: 500),
//           top: _getStatementTop(bordersAreaEdges),
//           bottom: _getStatementBottom(bordersAreaEdges),
//           left: _getStatementLeft(bordersAreaEdges),
//           width: 240,
//           child: Animate(
//               controller:AnimateController.setNewID("Instruction:<column>"),
//     startFrom: TransformData(y: 30),
//     child:Container(
//             padding: const EdgeInsets.all(15),
//     decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(25),
//         boxShadow: [BoxShadow(offset: const Offset(0,3),blurRadius: 14,color: Colors.black.withValues(alpha:0.1))]
//     ),
//     child:Column(children:[
//             Animate(
//                 controller:AnimateController.setNewID("Instruction:<statement>"),
//             startFrom: TransformData(y: 30),
//             child:Text(widget.data.statement,style: const TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center)),
//         const SizedBox(height:10),
//         Animate(
//             controller:AnimateController.setNewID("Instruction:<hide>"),
//             startFrom: TransformData(y: 30),
//             child:TextButton(
//           style: TextButton.styleFrom(
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             padding: const EdgeInsets.all(0),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//             ),
//             surfaceTintColor: Colors.transparent,
//             foregroundColor: Colors.blue
//           ),
//             onPressed: ()async{
//               Box box = await Hive.openBox('default');
//               await box.put("Instruction:${widget.data.id}", true);
//               _hide();
//               },
//             child: Text(w(51),style: const TextStyle(fontWeight: FontWeight.normal),textAlign: TextAlign.center)))]
//       )))),
//     ]));
//   }
// }
