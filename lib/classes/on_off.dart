import 'package:flowter/flowter.dart';

class OnOff {
  OnOff(this.value);

  bool value;

  void change() {
    value = !value;
  }

  Future<void> pendingState({
    required void Function() updateState,
    required Future<void> Function() process,
  }) async {
    if (value) throw Exception("The OnOff is already on.");

    value = true;

    bool currentBackButtonVisibility =
        TemplateController.currentTemplateData.shownBackButton;
    bool Function() currentBackFunction =
        TemplateController.currentTemplateData.onBackButtonPressed;

    TemplateController.updateCurrentTemplateData((data) => data
      ..onBackButtonPressed = () {
        return false;
      }
      ..shownBackButton = false);

    void returnBackFunction() =>
        TemplateController.updateCurrentTemplateData((data) => data
          ..onBackButtonPressed = currentBackFunction
          ..shownBackButton = currentBackButtonVisibility);

    updateState();
    try {
      await process();
      value = false;
      returnBackFunction();
      updateState();
    } catch (e) {
      value = false;
      returnBackFunction();
      updateState();
      rethrow;
    }
  }



  final Set<void Function(bool value)> _onChangedListeners = {};
  void addOnChangedListener(void Function(bool value) listener){
    _onChangedListeners.add(listener);
  }
  void removeOnChangedListener(void Function(bool value) listener){
    _onChangedListeners.remove(listener);
  }


}
