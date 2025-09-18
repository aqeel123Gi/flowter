// import 'package:flutter/material.dart';
// import '../classes/time.dart';
// import 'animated_transform_switcher/animated_transform_switcher.dart';
// import 'listed_text_picker.dart';
//
// class TimePicker extends StatefulWidget {
//   const TimePicker({
//     super.key,
//     required this.title,
//     required this.start,
//     required this.end,
//     required this.init,
//     required this.onChanged,
//   });
//
//   final String title;
//   final Time? start;
//   final Time? end;
//   final Time init;
//   final void Function(Time newTime) onChanged;
//
//   @override
//   State<TimePicker> createState() => _TimePickerState();
// }
//
// class _TimePickerState extends State<TimePicker> {
//
//   late Time _currentTime;
//
//   @override
//   void initState() {
//     _currentTime = widget.init;
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     // TextStyle style = TextStyle(color: CustomColor.primary,fontSize: 24);
//     Size size = const Size(70,70);
//
//
//     return Column(
//         children:[
//           const SizedBox(height: 20),
//           // TitleText(widget.title),
//           const SizedBox(height: 50),
//           Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//
//                 Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child:AnimatedTransformingSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         startY: 20,
//                         endY: -20,
//                         switcherKey: _currentTime.hour>=12,
//                         builder:(context, switcherKey)=>SizedBox(
//                             width: 30,
//                             child:Text(_currentTime.hour<12?"ص":"م",style: style,textAlign: TextAlign.center)))),
//                 // const SizedBox(width: 30),
//                 Row(
//                     textDirection: TextDirection.ltr,
//                     children:[
//                       ListedTextsPicker(
//                         decoration: BoxDecoration(
//                             border: Border.all(color: CustomColor.separatorLine(context),width: 2),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         size: size,
//                         initChoice: [7,8,9,10,11,12,1,2,3].indexOf(par(_currentTime.hour-(_currentTime.hour>12?12:0))),
//                         choices: [7,8,9,10,11,12,1,2,3].map<String>((e) => toStringWithZerosDigits(e,2)).toList(),
//                         textStyle: style,
//                         onChanged: (_,text){
//                           int hour = int.parse(text);
//                           setState(() {
//                             _currentTime.hour = hour+([12,1,2,3,4,5].contains(hour)?12:0);
//                           });
//                           widget.onChanged(_currentTime);
//
//                         },
//                       ),
//
//                 Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child:Text(":",style: style)),
//                       ListedTextsPicker(
//                         decoration: BoxDecoration(
//                             border: Border.all(color: CustomColor.separatorLine(context),width: 2),
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         size: size,
//                         initChoice: _currentTime.minute,
//                         choices: List.generate(60, (index) => toStringWithZerosDigits(index,2)),
//                         textStyle: style,
//                         onChanged: (_,text){
//                           setState(() {
//                             _currentTime.minute = int.parse(text);
//                           });
//                           widget.onChanged(_currentTime);
//
//                         },
//                       ),
//                 ]),
//
//               ]),
//           const SizedBox(height: 80),
//         ]);
//   }
// }