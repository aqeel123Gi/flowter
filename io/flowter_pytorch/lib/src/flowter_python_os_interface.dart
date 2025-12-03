abstract class FlowterPythonOsInterface {
  Future<void> initialize();
  Future<List<String>> installedPackages();
  Future<void> installPackage(String packageName);
}
