// import '../../classes/time.dart';
// import '../../functions/functions.dart';
//
// class DailyTasksController{
//
//   final List<DailyTask> _dailyTasks = [];
//
//   void Function(Object e,StackTrace s)? _onErrorThrown;
//
//   void setOnErrorThrown(void Function(Object e,StackTrace s) onThrown){
//     _onErrorThrown = onThrown;
//   }
//
//   void addTask(DailyTask task){
//     _dailyTasks.add_mod_del(task);
//   }
//
//   void removeTask(DailyTask task){
//     _dailyTasks.remove(task);
//   }
//
//   void removeWithTime(Time time){
//     _dailyTasks.removeWhere((element) => element.time == time);
//   }
//
//   void removeWithProcess(void Function() process){
//     _dailyTasks.removeWhere((element) => element.process == process);
//   }
//
//
//   void _loop(){
//
//     loopExecution(
//       function: (){
//
//       },
//       breakDuration: Duration()
//     );
//
//   }
//
//
//
//
// }
//
//
// class DailyTask{
//
//   final Time time;
//   final Duration randomShiftingDuration;
//   final void Function() process;
//
//   DailyTask({required this.time,required this.randomShiftingDuration,required this.process});
//
// }