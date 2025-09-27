class ProcessTimer{

  Duration? get lastDuration => _lastDuration;
  Duration? _lastDuration;
  DateTime? _dt;
  // String? _title;

  void point([String? title]){
    if(_dt==null){
      _dt = DateTime.now();
      // _title = title;
    }
    else{
      Duration difference = DateTime.now().difference(_dt!);
      _lastDuration = difference;
      // par(difference.toString(),"Time${_title==null?"":" $_title"}:");
      _dt = null;
      // _title = null;
    }

  }

}