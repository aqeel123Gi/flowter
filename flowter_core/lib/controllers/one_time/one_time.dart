class OneTimeInLifeCycle{

  static final Set _keys = {};

  static void execute(String key, void Function() function){
    if(!_keys.contains(key)){
      _keys.add(key);
      function();
    }
  }

}