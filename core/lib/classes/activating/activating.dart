class Activating<T>{
  Activating(this.value,this.on);
  T value;
  bool on;

  @override
  String toString() {
    return "Activating(value: $value, on: $on)";
  }

}