part of 'app_initializer.dart';

Future<void> logsInitialize() async {
  await Logs.initialize(
      '${(await getApplicationDocumentsDirectory()).path}/${AppFramework.appCustomization.filesDir}');

  Logs.add(category: 'app_activity', key: "APP STARTED", content: "");

  TemplateController.addListenerOnPagePushed((page) {
    Logs.add(category: 'app_activity', key: 'page_pushed', content: page.id);
  });

  TemplateController.addListenerOnPageSetAsHome((page) {
    Logs.add(category: 'activity', key: 'home_page', content: page.id);
  });

  TemplateController.addListenerOnPagePop((page) {
    Logs.add(category: 'activity', key: 'page_pop', content: page.id);
  });

  ApiController.addOnRequestCallback((path, type, headers, body) {
    Map debugHeaders = headers
        .withUpdatedKeys(["password", "Authorization", "Token"], (_) => "***");

    Map? debugBody;
    if (body != null && body is Map)
      debugBody = body.withUpdatedKeys(
          ["password", "Authorization", "Token"], (_) => "***", true);

    Logs.add(
      category: 'activity',
      key: 'api_request',
      content:
          "PATH: $path\nTYPE: ${type.name}\nHEAD: $debugHeaders${debugBody != null ? "\nBODY: $debugBody" : ""}",
    );
  });

  ApiController.addOnResponseCallback((path, type, code, headers, body) {
    Map debugHeaders = headers
        .withUpdatedKeys(["password", "Authorization", "Token"], (_) => "***");

    Map? debugBody;
    if (body != null && body is Map)
      debugBody = body.withUpdatedKeys(
          ["password", "Authorization", "Token"], (_) => "***", true);

    Logs.add(
      category: 'activity',
      key: 'api_response',
      content:
          "STATUS: $code\nHEAD: $debugHeaders${debugBody != null ? "\nBODY: $debugBody" : ""}",
    );
  });
}
