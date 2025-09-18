// import 'dart:typed_data';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:tahdir/assets/widgets/animated_visibility.dart';
//
// class ScreenRemoteController{
//
//   static final List<ScreenshotController> _screenshotController = [];
//   static final List<void Function()> _updateState = [];
//   static final List<GlobalKey> _keys = [];
//
//   static _update(){
//     for (void Function() updateState in _updateState) {
//       updateState();
//     }
//   }
//
//
//
//   static Widget body(Widget widget){
//     // return _Body(child: widget);
//     return widget;
//   }
//
//   static bool _onControlled = false;
//   static void startAsControlled()async{
//
//     _onControlled = true;
//
//     _update();
//
//     while(_onControlled){
//       await Future.delayed(const Duration(milliseconds: 1000));
//       Uint8List? data = await _screenshotController.last.capture();
//
//       if(data!=null){
//         // StackedDebugger.showImage(data);
//       }
//
//     }
//
//   }
//
//   static void click(Offset offset){
//
//     GestureBinding.instance.handlePointerEvent(PointerDownEvent(position: offset));
//     GestureBinding.instance.handlePointerEvent(PointerUpEvent(position: offset));
//   }
//
//   static void down(Offset offset){
//     GestureBinding.instance.handlePointerEvent(PointerDownEvent(position: offset));
//   }
//
//   static void up(Offset offset){
//     GestureBinding.instance.handlePointerEvent(PointerUpEvent(position: offset));
//   }
//
// }
//
// class _Body extends StatefulWidget {
//   const _Body({
//     Key? key,
//     required this.child
//   }) : super(key: key);
//
//   final Widget child;
//
//   @override
//   State<_Body> createState() => _BodyState();
// }
//
// class _BodyState extends State<_Body> {
//
//   late int _index;
//   final GlobalKey _key = GlobalKey();
//
//   @override
//   void initState() {
//     _index = ScreenRemoteController._screenshotController.length;
//     // ScreenRemoteController._screenshotController.add_mod_del(ScreenshotController());
//     ScreenRemoteController._updateState.add_mod_del(() {
//       if(mounted){
//         setState((){});}
//       }
//     );
//     ScreenRemoteController._keys.add_mod_del(_key);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ScreenRemoteController._update();
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     ScreenRemoteController._screenshotController.removeLast();
//     ScreenRemoteController._updateState.removeLast();
//     ScreenRemoteController._keys.removeLast();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ScreenRemoteController._update();
//     });
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox();
//     // return Screenshot(
//     //     controller: ScreenRemoteController._screenshotController[_index],
//     //     child: SizedBox(
//     //         child:widget.child)
//     // );
//     // return Stack(children:[
//     //     Screenshot(
//     //     controller: ScreenRemoteController._screenshotController[_index],
//     //     child: SizedBox(
//     //         child:widget.child)
//     //   ),
//     //   Positioned(
//     //       top: 5,bottom: 5,left: 5,right: 5,
//     //       child: IgnorePointer(child:AnimatedVisibility(
//     //           visible: ScreenRemoteController._onControlled && _index == ScreenRemoteController._keys.length-1,
//     //           child:Opacity(
//     //               opacity: 0.8,
//     //               child:Container(
//     //     decoration: BoxDecoration(border: Border.all(color: const Color(0xff00ff00), width: 1)),
//     //         child: Padding(
//     //             padding: const EdgeInsets.all(5),
//     //             child:AnimatedOpacity(
//     //               duration: const Duration(seconds: 1),
//     //                 opacity: 1,
//     //                 child:Row(
//     //                   mainAxisAlignment: MainAxisAlignment.start,
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     const SizedBox(width: 2),
//     //                     Container(
//     //                       margin: const EdgeInsets.only(top: 2),
//     //                       height: 10,
//     //                       width: 10,
//     //                       decoration: BoxDecoration(
//     //                           borderRadius: BorderRadius.circular(5),
//     //                           color:const Color(0xff00ff00))
//     //                     ),
//     //                     const SizedBox(width: 5),
//     //                     const Text("في حالة تحكم من قبل : مشعل",style: TextStyle(color:Color(0xff00ff00),fontSize: 9))
//     //           ]))),
//     //   )))))
//     // ]);
//   }
// }
