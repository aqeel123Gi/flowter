import 'package:flowter_python/src/flowter_python_os_interface.dart';
import 'package:py_engine_desktop/py_engine_desktop.dart';

class FlowterPythonWindows implements FlowterPythonOsInterface {

  @override
  Future<void> initialize() async {
    await PyEngineDesktop.init();
  }

  @override
  Future<void> installPackage(String packageName) async {
    await PyEngineDesktop.pipInstall(packageName);
    print('Package $packageName installed');
  }

  
  Future<> runPythonScript(String scriptPath) async {
    
  }

}
