class OnChangingValue<T> {

  OnChangingValue(this.lastValue);

  T lastValue;

  void set({required T value, required void Function() onChanged}) {
    if (lastValue != value) {
      lastValue = value;
      onChanged();
    }
  }

  void setOn({required bool Function() condition, required T value, required void Function() onChanged}) {
    if (lastValue != value && condition()) {
      lastValue = value;
      onChanged();
    }
  }

}